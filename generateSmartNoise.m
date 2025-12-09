function [smartNoise, params] = generateSmartNoise(radarParams)
    % 灵巧噪声干扰（信号相关噪声）
    PRI = radarParams.PRI;
    PW = radarParams.PulseWidth;
    fs = radarParams.SamplingFrequency;
    fc = radarParams.CarrierFrequency;
    
    % 生成雷达信号副本
    t = 0:1/fs:PW-1/fs;
    pulse = exp(1j*2*pi*fc*t);
    
    % 生成5个脉冲的干扰
    numPulses = 5;
    samplesPerPRI = round(PRI * fs);
    smartNoise = zeros(1, numPulses * samplesPerPRI);
    
    for i = 1:numPulses
        startIdx = (i-1)*samplesPerPRI + 1;
        endIdx = min(startIdx + length(pulse) - 1, length(smartNoise));
        
        if endIdx > startIdx
            % 生成与雷达信号相关的噪声
            noise = 0.5 * (randn(size(pulse)) + 1i*randn(size(pulse)));
            correlatedNoise = conv(pulse, noise, 'same');
            
            smartNoise(startIdx:endIdx) = correlatedNoise(1:(endIdx-startIdx+1));
        end
    end
    
    params = struct(...
        'Type', 'Smart Noise', ...
        'CorrelationLevel', 0.7, ...
        'NumPulses', numPulses);
end
