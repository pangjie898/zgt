function [vgpo, params] = generateVelocityGatePullOff(radarParams)
    % 速度波门拖引干扰
    PRI = radarParams.PRI;
    PW = radarParams.PulseWidth;
    fs = radarParams.SamplingFrequency;
    fc = radarParams.CarrierFrequency;
    
    % 干扰参数
    dragTime = 8 * PRI;     % 拖引时间
    maxDoppler = 50e3;      % 最大多普勒频移 (Hz)
    numPulses = ceil(dragTime / PRI);
    
    % 生成拖引信号
    samplesPerPRI = round(PRI * fs);
    vgpo = zeros(1, numPulses * samplesPerPRI);
    t = (0:length(vgpo)-1)/fs;
    
    for i = 1:numPulses
        % 计算当前多普勒频移（线性增加）
        dopplerShift = min(i * maxDoppler / numPulses, maxDoppler);
        freq = fc + dopplerShift;
        
        startIdx = (i-1)*samplesPerPRI + 1;
        endIdx = min(startIdx + round(PW * fs) - 1, length(vgpo));
        
        if endIdx > startIdx
            pulseT = t(startIdx:endIdx) - t(startIdx);
            vgpo(startIdx:endIdx) = exp(1j*2*pi*freq*pulseT);
        end
    end
    
    params = struct(...
        'Type', 'Velocity Gate Pull Off', ...
        'DragTime', dragTime, ...
        'MaxDoppler', maxDoppler, ...
        'NumPulses', numPulses);
end