function SignalOut = FuncSignalWithAntennaScanningAmplitude(...
    AntennaScanningCycle, fs, Signal, ...
    AntennaScanningCycleNum, AntennaScanningAmplitude, RoundFirstPulseToa)
    
    % 计算总采样点数
    samplesPerCycle = length(AntennaScanningAmplitude);
    totalSamples = length(Signal);
    
    % 扩展天线扫描幅度
    fullScanAmp = repmat(AntennaScanningAmplitude, 1, AntennaScanningCycleNum);
    if length(fullScanAmp) < totalSamples
        fullScanAmp = [fullScanAmp, repmat(AntennaScanningAmplitude, 1, ...
            ceil((totalSamples - length(fullScanAmp))/samplesPerCycle))];
    end
    fullScanAmp = fullScanAmp(1:totalSamples);
    
    % 应用幅度调制（直接操作，避免创建临时数组）
    firstPulseSamples = round(RoundFirstPulseToa * fs);
    SignalOut = Signal;
    SignalOut(firstPulseSamples+1:end) = ...
        Signal(firstPulseSamples+1:end) .* fullScanAmp(firstPulseSamples+1:end);

%% 可视化
figure;
t = (0:totalSamples-1)/fs;
subplot(2,1,1);
plot(t, real(SignalOut), 'b', 'LineWidth', 1.2);
grid on;
xlabel('时间 (s)');
ylabel('幅度');
title('时域信号');
xlim([t(1), t(end)]);

% 执行FFT
Y = fft(SignalOut);
P2 = abs(Y/totalSamples);             % 双边幅度谱
P1 = P2(1:floor(totalSamples/2)+1);   % 取正频率部分

% 调整幅度（直流分量不变，其他分量乘2）
P1(2:end-1) = 2*P1(2:end-1);            % 适用于偶数长度信号
if mod(totalSamples,2) == 1             % 奇数长度信号处理
    P1(2:end) = 2*P1(2:end);
end

% 生成频率轴
f = fs*(0:floor(totalSamples/2))/totalSamples;

% 绘制频域图
subplot(2,1,2);
plot(f, P1, 'r', 'LineWidth', 1.5);
grid on;
xlabel('频率 (Hz)');
ylabel('幅度');
title('频域');
xlim([0, fs/2]);           % 显示0到Nyquist频率

% 优化布局
sgtitle('信号时/频域图');
end