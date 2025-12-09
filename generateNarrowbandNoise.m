function [narrowNoise, params] = generateNarrowbandNoise(radarParams)
    % 窄带噪声干扰
    pw = radarParams.PulseWidth;
    pri = radarParams.PRI;
    fs = radarParams.SamplingFrequency;
    fc = radarParams.CarrierFrequency;
    
    % 生成5个脉冲的干扰
    numPulses = 5;
    samplesPerPulse = round(pri * fs);
    narrowNoise = zeros(1, numPulses * samplesPerPulse);
    
    for i = 1:numPulses
        startIdx = (i-1)*samplesPerPulse + 1;
        endIdx = startIdx + round(pw * fs) - 1;
        
        % 生成带限噪声
        noise = randn(1, round(pw * fs)) + 1i*randn(1, round(pw * fs));
        bw = 0.1 * fc; % 带宽为中心频率的10%
        [b, a] = butter(6, bw/(fs/2));
        noise = filter(b, a, noise);
        
        narrowNoise(startIdx:endIdx) = noise;
    end
    
    params = struct(...
        'Type', 'Narrowband Noise', ...
        'CenterFrequency', fc, ...
        'Bandwidth', bw, ...
        'NumPulses', numPulses, ...
        'JSR', 15);
end