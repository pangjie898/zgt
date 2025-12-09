function [SignalAfterDigitalChannelization, ChannelNumAfterDigitalChannelization, SignalAfterDigitalChannelizationTotal] = ...
    FuncDigitalChannelization(ChannelNum, ReceivedSignal, SamplingFrequency, varargin)
%% 函数功能：数字信道化 - 基于多相滤波器组结构
%  输入：
%      ChannelNum: 信道数目（抽取倍数）
%      ReceivedSignal: 接收信号（实信号或复信号）
%      SamplingFrequency: 采样频率 (Hz)
%      'Plot' (可选): 启用可视化，例如 'Plot','All' 或 'Plot','Valid'
%  输出：
%      SignalAfterDigitalChannelization: 信道化后信号（仅含有效信道）
%      ChannelNumAfterDigitalChannelization: 有效信道数量
%      SignalAfterDigitalChannelizationTotal: 所有信道信号
%
% 原理说明：
%   1. 设计截止频率为fs/(2D)的原型低通滤波器
%   2. 对输入信号和滤波器进行D倍抽取（多相分解）
%   3. 对多相分支进行并行滤波
%   4. 通过FFT实现高效信道划分
%   5. 动态噪声估计与信道检测

%% 参数解析与初始化
p = inputParser;
addOptional(p, 'Plot', 'None', @(x)ismember(x,{'None','Valid','All'}));
parse(p, varargin{:});
plotOption = p.Results.Plot;

D = ChannelNum;  % 信道数 = 抽取倍数
L = 256;         % 滤波器长度（需为D的整数倍）
filter_proto = designfilt('lowpassfir', 'FilterOrder', L-1, ...
                         'CutoffFrequency', SamplingFrequency/(2*D), ...
                         'SampleRate', SamplingFrequency);
filter_coeffs = filter_proto.Coefficients;

% 确保滤波器长度为D的整数倍
if mod(length(filter_coeffs), D) ~= 0
    filter_coeffs = [filter_coeffs, zeros(1, D - mod(length(filter_coeffs), D))];
end
L_total = length(filter_coeffs);
L_poly = L_total / D;  % 每个多相分支的长度

% 处理输入信号
data = ReceivedSignal(:).';
len_data = length(data);
if mod(len_data, D) ~= 0
    data = [data, zeros(1, D - mod(len_data, D))];
end
len_data_new = length(data);

% 数据分路 - 多相分解
data_poly = reshape(data, D, []);
len_poly = size(data_poly, 2);  % 每路数据长度

% 滤波器多相分解
filter_poly = reshape(filter_coeffs, D, L_poly);

%% 多相滤波处理
% 预分配输出矩阵
subchannel_output = zeros(D, len_poly + L_poly - 1);

% 并行多相滤波
for i = 1:D
    subchannel_output(i, :) = conv(data_poly(i, :), filter_poly(i, :));
end

% FFT实现信道化
subchannel_output = fft(subchannel_output, D, 1) / D;

%% 信道检测与选择
% 动态噪声估计 - 使用最小功率法
channel_power = mean(abs(subchannel_output).^2, 2);
noise_floor = prctile(channel_power, 10);  % 使用10%分位数作为噪声基底
threshold = 10^(10/10) * noise_floor;      % 10dB阈值

% 检测有效信道
valid_channels = channel_power > threshold;
ChannelNumAfterDigitalChannelization = sum(valid_channels);
SignalAfterDigitalChannelization = subchannel_output(valid_channels, :);
SignalAfterDigitalChannelizationTotal = subchannel_output;

%% 高级可视化
if ~strcmp(plotOption, 'None')
    % 创建图形窗口
    fig = figure('Name', '数字信道化分析', 'Position', [100, 100, 1600, 750], 'Color', 'w');
    
    % 1. 输入信号频谱
    subplot(3, 2, [1, 2]);
    [Pxx, F] = pwelch(data, hanning(1024), 512, 1024, SamplingFrequency);
    plot(F/1e6, 10*log10(Pxx), 'LineWidth', 1.5);
    title('输入信号频谱');
    xlabel('频率 (MHz)');
    ylabel('功率谱密度 (dB/Hz)');
    grid on;
    xlim([0, SamplingFrequency/2e6]);
    
    % 2. 信道功率分布
    subplot(3, 2, 3);
    
    % 修正：计算正确的中心频率 (k+0.5)*fs/D
    freq_bins = ((0:D-1)) * (SamplingFrequency/D) / 1e6;
    
    bar(freq_bins, 10*log10(channel_power), 'FaceColor', [0.2, 0.6, 0.8]);
    hold on;
    plot([0, max(freq_bins)], 10*log10([threshold, threshold]), 'r--', 'LineWidth', 1.5);
    title('信道功率分布');
    xlabel('中心频率 (MHz)');
    ylabel('功率 (dB)');
    legend('信道功率', '检测阈值', 'Location', 'Best');
    grid on;

    % 添加频率刻度标记
    xticks(freq_bins(1:min(D, 8))); % 最多显示8个刻度
    xticklabels(arrayfun(@(x) sprintf('%.1f', x), freq_bins(1:min(D, 8)), 'UniformOutput', false));
    
    % 设置合理的X轴范围
    xlim([0, SamplingFrequency/2e6]); % 只显示正频率部分
    
    % 3. 有效信道标记
    subplot(3, 2, 4);
    stem(freq_bins, valid_channels, 'filled', 'LineWidth', 2, 'MarkerSize', 8);
    title('有效信道检测结果');
    xlabel('中心频率 (MHz)');
    ylabel('信道状态 (0/1)');
    ylim([-0.1, 1.1]);
    grid on;
    
    % 4. 信道化输出频谱（所有信道或有效信道）
    subplot(3, 1, 3);
    hold on;
    
    colors = lines(min(16, D));  
    
    if strcmp(plotOption, 'All')
        display_channels = 1:D;
    else
        display_channels = find(valid_channels);
    end
    
    for idx = 1:min(length(display_channels), 16)
        ch = display_channels(idx);
        ch_data = subchannel_output(ch, :);
        [Pxx_ch, F_ch] = pwelch(ch_data, hanning(512), 256, 512, SamplingFrequency/D);
        plot(F_ch/1e6 + freq_bins(ch), 10*log10(Pxx_ch), ...
            'LineWidth', 1, 'Color', colors(idx, :), ...
            'DisplayName', sprintf('信道 %d ', ch)); 
    end
    
    title('信道化输出频谱');
    xlabel('频率 (MHz)');
    ylabel('功率谱密度 (dB/Hz)');
    legend('show', 'Location', 'Best');
    grid on;
    xlim([0, SamplingFrequency/2e6]);
    ylim([-100, 0]);
    
    % 添加原理说明
    annotation(fig, 'textbox', [0.05, 0.01, 0.9, 0.05], ...
        'String', sprintf('多相滤波信道化 (D=%d, L=%d) | 有效信道: %d/%d | 采样率: %.2f MHz', ...
        D, L_total, ChannelNumAfterDigitalChannelization, D, SamplingFrequency/1e6), ...
        'EdgeColor', 'none', 'HorizontalAlignment', 'center', ...
        'FontSize', 10, 'FontWeight', 'bold');
end
end