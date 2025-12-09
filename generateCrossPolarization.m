function [polarizationJam, params] = generateCrossPolarization(radarParams)
    % 交叉极化干扰
    PRI = radarParams.PRI;
    PW = radarParams.PulseWidth;
    fs = radarParams.SamplingFrequency;
    fc = radarParams.CarrierFrequency;
    
    % 生成5个脉冲的干扰
    numPulses = 5;
    samplesPerPRI = round(PRI * fs);
    polarizationJam = zeros(1, numPulses * samplesPerPRI);
    t = (0:length(polarizationJam)-1)/fs;
    
    % 生成正交极化信号（90度相位偏移）
    for i = 1:numPulses
        startIdx = (i-1)*samplesPerPRI + 1;
        endIdx = min(startIdx + round(PW * fs) - 1, length(polarizationJam));
        
        if endIdx > startIdx
            pulseT = t(startIdx:endIdx) - t(startIdx);
            polarizationJam(startIdx:endIdx) = 1j * exp(1j*2*pi*fc*pulseT);
        end
    end
    
    params = struct(...
        'Type', 'Cross Polarization', ...
        'PolarizationAngle', 90, ... % 度
        'NumPulses', numPulses);
end