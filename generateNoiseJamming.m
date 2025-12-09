function [noiseJam, params] = generateNoiseJamming(radarParams)
    % 宽带噪声干扰
    duration = 100e-6; % 干扰持续时间
    fs = radarParams.SamplingFrequency;
    N = round(duration * fs);
    
    % 生成高斯噪声
    noiseJam = randn(1, N) + 1i*randn(1, N);
    
    % 参数记录
    params = struct(...
        'Type', 'Broadband Noise', ...
        'Duration', duration, ...
        'Bandwidth', fs, ...
        'JSR', 20); % 干信比
end