function [rgpo, params] = generateRangeGatePullOff(radarParams)
    % 距离波门拖引干扰
    PRI = radarParams.PRI;
    PW = radarParams.PulseWidth;
    fs = radarParams.SamplingFrequency;
    
    % 干扰参数
    dragTime = 5 * PRI;     % 拖引时间
    dragRate = 1.5e6;       % 拖引速率 (m/s)
    numPulses = ceil(dragTime / PRI);
    
    % 生成拖引信号
    samplesPerPRI = round(PRI * fs);
    rgpo = zeros(1, numPulses * samplesPerPRI);
    t = (0:length(rgpo)-1)/fs;
    carrier = exp(1j*2*pi*radarParams.CarrierFrequency*t);
    
    for i = 1:numPulses
        % 计算当前延迟
        delay = min(i * dragRate * PRI / 3e8, 10 * PW);
        startIdx = round((i-1)*PRI*fs + delay*fs);
        endIdx = min(startIdx + round(PW * fs) - 1, length(rgpo));
        
        if endIdx > startIdx && endIdx <= length(rgpo)
            rgpo(startIdx:endIdx) = 1;
        end
    end
    
    % 添加载频
    rgpo = rgpo .* carrier;
    
    % 参数记录
    params = struct(...
        'Type', 'Range Gate Pull Off', ...
        'DragTime', dragTime, ...
        'DragRate', dragRate, ...
        'NumPulses', numPulses);
end