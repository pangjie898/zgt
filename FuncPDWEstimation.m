function [freqEst, priEst, ampEst, pwEst, toaEst] = ...
    FuncPDWEstimation(signal, fs)
% 增强版PDW估计函数 - 可靠检测可见脉冲
% 输入：多阵元信号（阵元数×信号长度），采样频率
% 输出：脉冲参数估计值

% ==================== 参数设置 ====================
minPulseGap = round(0.1e-6 * fs);       % 100ns最小脉冲间隔
pwRatioThreshold = 0.15;                % 脉宽归一化比值阈值
priRatioThreshold = 0.07;              % PRI归一化比值阈值
minPulseSamples = round(0.05e-6 * fs);  % 50ns最小脉宽
displayPulses = 3;                      % 显示脉冲数量
displayPRIs = 5;                        % 显示PRI数量
Pfa = 1e-6;                             % 虚警概率
N = 1;                                  % 检测样本数（逐点检测）

% ==================== 信号预处理 ====================
% 多阵元平均功率
combinedPower = sum(abs(signal).^2, 1) / size(signal,1);

% ==================== 鲁棒噪声估计 ====================
% 使用信号开头估计噪声（更可靠）
noiseStart = max(1, min(2000, size(signal,2)));
noiseData = signal(:, 1:noiseStart);

% 鲁棒性检查：确保噪声段功率不超过信号最大功率的1%
if mean(abs(noiseData(:)).^2) > 0.01 * max(combinedPower)
    % 如果开头噪声估计异常，尝试中间段
    midPoint = round(size(signal,2)/2);
    noiseData = signal(:, midPoint:midPoint+1000);
    fprintf('警告：使用信号中间段估计噪声\n');
end

noiseVar = mean(abs(noiseData(:)).^2);  % 噪声方差σ²估计

% ==================== 自适应门限计算 ====================
Q_inv = sqrt(2)*erfcinv(2*Pfa);
baseThreshold = noiseVar * (1 + sqrt(2/N) * Q_inv);

% 自适应调整：如果信号峰值远高于门限，适当降低要求
peakPower = max(combinedPower);
if peakPower > 10 * baseThreshold
    adaptiveFactor = 0.7;  % 降低门限要求
else
    adaptiveFactor = 0.4;
end
threshold = baseThreshold * adaptiveFactor;

% ==================== 能量检测 ====================
pulseMask = combinedPower > threshold;  % 检测判决

% ==================== 动态初始形态学处理 ====================
% 估计平均脉冲宽度（基于超过门限的样本）
aboveThreshold = pulseMask;
pulseDensity = sum(aboveThreshold) / length(aboveThreshold);

% 动态设置结构元素大小
baseSize = max(3, round(pulseDensity * 50));  % 基于脉冲密度
dilationElement = ones(1, baseSize);
erosionElement = ones(1, round(baseSize*1.5));

dilatedMask = imdilate(aboveThreshold, dilationElement);
processedMask = imerode(dilatedMask, erosionElement);

% ==================== 脉冲段检测 ====================
% 使用增强的脉冲段检测函数
[pulseStarts, pulseEnds] = findPulseSegments(processedMask, combinedPower, threshold, fs);
numPulses = length(pulseStarts);

% ==================== 脉宽估计与筛选 ====================
if numPulses > 0
    % 计算脉宽（样本数）
    rawPwSamples = pulseEnds - pulseStarts;
    
    % 脉宽筛选
    validPulses = true(1, numPulses);
    if numPulses > 2
        meanPw = mean(rawPwSamples);
        for i = 1:numPulses
            % 最小脉宽检查
            if rawPwSamples(i) < minPulseSamples
                validPulses(i) = false;
                continue;
            end
            
            % 归一化比值检查
            normRatio = abs(rawPwSamples(i) - meanPw) / meanPw;
            if normRatio > pwRatioThreshold
                validPulses(i) = false;
            end
        end
    end
    
    % 更新有效脉冲索引
    validIndices = find(validPulses);
    numValidPulses = length(validIndices);
else
    numValidPulses = 0;
    validIndices = [];
end

% ==================== 主可视化 ====================
mainFig = figure('Name', 'PDW估计结果', 'Position', [100, 100, 1400, 800]);

% ==================== 参数提取 ====================
freqEst = zeros(1, numValidPulses);
ampEst = zeros(1, numValidPulses);
pwEst = zeros(1, numValidPulses);
toaEst = zeros(1, numValidPulses);

% 信号功率与检测门限图
ax1 = subplot(2,2,[1,2]);
plot((1:length(combinedPower))/fs*1e6, combinedPower, 'b', 'LineWidth', 1);
hold on;
plot([1, length(combinedPower)]/fs*1e6, [threshold, threshold], 'r--', 'LineWidth', 1.5);

% 标记所有检测到的脉冲
for i = 1:min(displayPulses, numPulses)
    startIdx = pulseStarts(i);
    endIdx = pulseEnds(i);
    duration = (endIdx - startIdx)/fs*1e6;
    
    % 绘制脉冲区域
    fillX = [startIdx, endIdx, endIdx, startIdx]/fs*1e6;
    fillY = [0, 0, max(combinedPower)*0.2, max(combinedPower)*0.2];
    
    if ismember(i, validIndices)
        % 有效脉冲 - 绿色
        fill(fillX, fillY, 'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        text(mean(fillX), max(combinedPower)*0.25, sprintf('P%d (%.1fμs)', i, duration), ...
            'HorizontalAlignment', 'center', 'FontSize', 10);
    else
        % 无效脉冲 - 红色
        fill(fillX, fillY, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
        text(mean(fillX), max(combinedPower)*0.3, sprintf('无效%d (%.1fμs)', i, duration), ...
            'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'r');
    end
end

% 添加门限信息
text(0.05, 0.95, sprintf('检测门限: %.2e', threshold), ...
    'Units', 'normalized', 'FontSize', 10, 'Color', 'r');

title('信号功率与脉冲检测', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('时间 (μs)', 'FontSize', 12);
ylabel('功率', 'FontSize', 12);
legend('信号功率', '检测门限', 'Location', 'best');
grid on;
xlim([0, length(combinedPower)/fs*1e6]);
ylim([0, max(combinedPower)*1.3]);

% ==================== 参数提取 ====================
if numValidPulses > 0
    for j = 1:numValidPulses
        idx = validIndices(j);
        startIdx = pulseStarts(idx);
        endIdx = pulseEnds(idx);
        
        % 脉宽估计
        pwEst(j) = (endIdx - startIdx) / fs;
        
        % 到达时间估计
        toaEst(j) = startIdx / fs;
        
        % 频率估计 (STFT方法)        
        pulseData = signal(1, startIdx:endIdx);
        freqEst(j) = estimateFrequency(pulseData, fs);

        % 幅度估计
        ampEst(j) = mean(abs(pulseData));
    end
end

% ==================== PRI估计 ====================
if numValidPulses > 2
    priEst = estimatePRI(toaEst, fs, priRatioThreshold);     %差分法
    
    % 绘制PRI估计结果
    ax2 = subplot(2,2,3);
    priIntervals = diff(toaEst)*1e6; % 转换为微秒
    
    % 简单绘制所有PRI
    bar(1:min(displayPRIs, length(priIntervals)), priIntervals(1:min(displayPRIs, end)), 'FaceColor', [0.2, 0.6, 0.8]);
    
    % 添加平均值线
    if ~isempty(priEst)
        hold on;
        plot([0, min(displayPRIs, length(priIntervals))+1], [priEst*1e6, priEst*1e6], 'r--', 'LineWidth', 1.5);
    end
    
    title('脉冲重复间隔 (PRI)', 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('间隔序号', 'FontSize', 12);
    ylabel('时间 (μs)', 'FontSize', 12);
    grid on;
else
    priEst = [];
    ax2 = subplot(2,2,3);
    if numValidPulses > 0
        text(0.5, 0.5, '有效脉冲数量不足，无法估计PRI', ...
            'HorizontalAlignment', 'center', 'FontSize', 12);
    else
        text(0.5, 0.5, '未检测到有效脉冲', ...
            'HorizontalAlignment', 'center', 'FontSize', 12);
    end
    axis off;
end

% ==================== 脉冲参数表格 ====================
ax3 = subplot(2,2,4);
if numValidPulses > 0
    % 创建参数表格
    pulseData = zeros(min(10, numValidPulses), 4);
    for j = 1:min(10, numValidPulses)
        pulseData(j,:) = [toaEst(j)*1e6, freqEst(j)/1e6, pwEst(j)*1e6, ampEst(j)];
    end
    
    % 创建uitable
    t = uitable('Parent', mainFig, 'Data', pulseData, ...
        'ColumnName', {'TOA(μs)', 'Freq(MHz)', 'PW(μs)', 'Amplitude'}, ...
        'RowName', compose('P%d', 1:size(pulseData,1)), ...
        'Units', 'normalized', 'Position', [0.55, 0.1, 0.4, 0.35]);
    
    % 设置表格样式
    t.FontSize = 11;
    t.ColumnWidth = {80, 80, 80, 90};
    
    % 添加标题
    uicontrol('Style', 'text', 'String', '有效脉冲参数', ...
        'Units', 'normalized', 'Position', [0.55, 0.46, 0.4, 0.04], ...
        'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.8, 0.9, 1]);
    
    % 添加统计信息
    infoStr = sprintf('检测脉冲: %d, 有效脉冲: %d', numPulses, numValidPulses);
    uicontrol('Style', 'text', 'String', infoStr, ...
        'Units', 'normalized', 'Position', [0.55, 0.05, 0.4, 0.04], ...
        'FontSize', 11, 'FontWeight', 'bold', 'BackgroundColor', [1, 0.9, 0.8]);
    
    % 添加平均PRI信息
    if ~isempty(priEst)
        uicontrol('Style', 'text', 'String', sprintf('平均PRI: %.2f μs', priEst*1e6), ...
            'Units', 'normalized', 'Position', [0.55, 0.01, 0.4, 0.04], ...
            'FontSize', 11, 'FontWeight', 'bold', 'BackgroundColor', [1, 0.9, 0.8]);
    end
else
    text(0.5, 0.5, '未检测到有效脉冲', ...
        'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
    axis off;
end

% 添加调试信息
fprintf('噪声功率: %.2e\n', noiseVar);
fprintf('计算门限: %.2e (自适应因子: %.2f)\n', threshold, adaptiveFactor);
fprintf('信号峰值: %.2e (SNR: %.1f dB)\n', peakPower, 10*log10(peakPower/noiseVar));
fprintf('检测到%d个脉冲，处理后保留%d个有效脉冲\n', numPulses, numValidPulses);

end




