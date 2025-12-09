function [compressed, t] = pulseCompression(signal, params)
    % 仅对LFM信号有效
    if params.SignalType ~= 4
        compressed = abs(signal);
        t = (0:length(signal)-1)/params.SamplingFrequency;
        return;
    end
    
    fs = params.SamplingFrequency;
    T = params.PulseWidth;
    B = params.BandWidth;
    N = length(signal);
    
    % 生成匹配滤波器
    t_chirp = -T/2:1/fs:T/2;
    chirp = exp(1j*pi*(B/T)*t_chirp.^2);
    
    % 脉冲压缩
    compressed = conv(signal, conj(fliplr(chirp)), 'same');
    
    % 时间轴
    t = (0:N-1)/fs - T/2;
end