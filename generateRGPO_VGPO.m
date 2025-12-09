function [comboJam, params] = generateRGPO_VGPO(radarParams)
    % 距离-速度同步拖引干扰
    PRI = radarParams.PRI;
    PW = radarParams.PulseWidth;
    fs = radarParams.SamplingFrequency;
    fc = radarParams.CarrierFrequency;
    
    % 干扰参数
    dragTime = 10 * PRI;    % 拖引时间
    dragRate = 1.2e6;       % 距离拖引速率 (m/s)
    maxDoppler = 40e3;      % 最大多普勒频移 (Hz)
    numPulses = ceil(dragTime / PRI);
    
    % 生成组合干扰信号
    samplesPerPRI = round(PRI * fs);
    comboJam = zeros(1, numPulses * samplesPerPRI);
    t = (0:length(comboJam)-1)/fs;
    
    for i = 1:numPulses
        % 计算当前距离延迟
        rangeDelay = min(i * dragRate * PRI / 3e8, 15 * PW);
        
        % 计算当前多普勒频移
        dopplerShift = min(i * maxDoppler / numPulses, maxDoppler);
        
        startIdx = round((i-1)*PRI*fs + rangeDelay*fs);
        endIdx = min(startIdx + round(PW * fs) - 1, length(comboJam));
        
        if endIdx > startIdx
            pulseT = t(startIdx:endIdx) - t(startIdx);
            freq = fc + dopplerShift;
            comboJam(startIdx:endIdx) = exp(1j*2*pi*freq*pulseT);
        end
    end
    
    params = struct(...
        'Type', 'RGPO+VGPO Combo', ...
        'DragTime', dragTime, ...
        'DragRate', dragRate, ...
        'MaxDoppler', maxDoppler, ...
        'NumPulses', numPulses);
end