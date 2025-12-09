function [falseTargets, params] = generateDenseFalseTargets(radarParams)
    % 密集假目标干扰
    PRI = radarParams.PRI;
    PW = radarParams.PulseWidth;
    fs = radarParams.SamplingFrequency;
    fc = radarParams.CarrierFrequency;
    
    % 生成基础脉冲
    t = 0:1/fs:PW-1/fs;
    pulse = exp(1j*2*pi*fc*t);
    
    % 生成10个假目标
    numFalseTargets = 10;
    numPulses = 5;
    samplesPerPRI = round(PRI * fs);
    falseTargets = zeros(1, numPulses * samplesPerPRI);
    
    for p = 1:numPulses
        for tgt = 1:numFalseTargets
            % 随机延迟 (0-20 μs)
            delay = randi([0, round(20e-6*fs)]);
            startIdx = (p-1)*samplesPerPRI + 1 + delay;
            endIdx = startIdx + length(pulse) - 1;
            
            if endIdx <= length(falseTargets)
                % 随机幅度 (0.2-1.0)
                amplitude = 0.2 + 0.8*rand();
                falseTargets(startIdx:endIdx) = falseTargets(startIdx:endIdx) + ...
                    amplitude * pulse;
            end
        end
    end
    
    params = struct(...
        'Type', 'Dense False Targets', ...
        'NumTargetsPerPulse', numFalseTargets, ...
        'NumPulses', numPulses, ...
        'MaxDelay', 20e-6);
end