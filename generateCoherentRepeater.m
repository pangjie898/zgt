function [coherentJam, params] = generateCoherentRepeater(radarParams)
    % 相干转发干扰
    PRI = radarParams.PRI;
    PW = radarParams.PulseWidth;
    fs = radarParams.SamplingFrequency;
    fc = radarParams.CarrierFrequency;
    
    % 生成雷达信号副本（简化模型）
    t = 0:1/fs:PW-1/fs;
    pulse = exp(1j*2*pi*fc*t);
    
    % 添加微小调制
    modFreq = 10e3; % 10 kHz调制
    pulse = pulse .* exp(1j*2*pi*modFreq*t);
    
    % 生成5个脉冲的干扰
    numPulses = 5;
    samplesPerPRI = round(PRI * fs);
    coherentJam = zeros(1, numPulses * samplesPerPRI);
    
    for i = 1:numPulses
        startIdx = (i-1)*samplesPerPRI + 1;
        endIdx = startIdx + length(pulse) - 1;
        
        if endIdx <= length(coherentJam)
            coherentJam(startIdx:endIdx) = pulse;
        end
    end
    
    params = struct(...
        'Type', 'Coherent Repeater', ...
        'ModulationFreq', modFreq, ...
        'Delay', 0, ...
        'Gain', 1.5, ...
        'NumPulses', numPulses);
end