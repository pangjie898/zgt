function jamSignal = generateJammingSignal(decision, radarSignal, params)
    fs = params.SamplingFrequency;
    N = length(radarSignal);
    t = (0:N-1)/fs;
    
    switch decision.JammingType
        case 1 % 窄带瞄频干扰
            % 中心频率为雷达载频
            centerFreq = params.CarrierFrequency;
            % 生成窄带高斯噪声
            noise = randn(1, N) + 1j*randn(1, N);
            % 带通滤波（简化实现）
            jamSignal = noise .* exp(1j*2*pi*centerFreq*t);
            
        case 4 % 梳状谱干扰
            % 在多个频点生成干扰
            numFreqs = 5;
            freqStep = 10e6;
            startFreq = params.CarrierFrequency - (numFreqs-1)/2 * freqStep;
            jamSignal = zeros(1, N);
            for k = 1:numFreqs
                freq = startFreq + (k-1)*freqStep;
                phase = 2*pi*rand(); % 随机相位
                jamSignal = jamSignal + cos(2*pi*freq*t + phase);
            end
            
        case 5 % 灵巧噪声干扰
            % 生成与雷达信号相关的噪声
            noise = randn(1, N) + 1j*randn(1, N);
            % 与雷达信号卷积
            jamSignal = conv(radarSignal, noise, 'same');
            
        case 8 % 距离速度联合拖引干扰
            % 创建延时版本
            delaySamples = round(params.PulseWidth * fs * 0.8);
            jamSignal = [zeros(1, delaySamples), radarSignal(1:end-delaySamples)];
            
            % 添加多普勒频移
            dopplerShift = 100e3; % 100 kHz
            jamSignal = jamSignal .* exp(1j*2*pi*dopplerShift*t);
            
        case 9 % 密集假目标复制干扰
            % 生成多个假目标
            numTargets = 10;
            minDelay = params.PulseWidth * fs * 0.1;
            maxDelay = params.PulseWidth * fs * 2;
            delays = round(linspace(minDelay, maxDelay, numTargets));
            
            jamSignal = zeros(1, N);
            for k = 1:numTargets
                delay = delays(k);
                if delay < N
                    jamSignal(delay+1:end) = jamSignal(delay+1:end) + ...
                        radarSignal(1:end-delay) * (1 - 0.1*k);
                end
            end
            
        case 10 % 间歇采样转发干扰
            % 采样占空比
            dutyCycle = 0.3;
            sampleLen = round(params.PulseWidth * fs * dutyCycle);
            totalSamples = length(radarSignal);
            
            jamSignal = zeros(1, totalSamples);
            startIdx = 1;
            while startIdx < totalSamples
                endIdx = min(startIdx + sampleLen - 1, totalSamples);
                jamSignal(startIdx:endIdx) = radarSignal(startIdx:endIdx);
                startIdx = startIdx + round(sampleLen / dutyCycle);
            end
            
        otherwise
            jamSignal = zeros(size(radarSignal));
    end
end