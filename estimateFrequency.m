function freqEst = estimateFrequency(pulseData, fs)
    N = length(pulseData);
    if N < 20  % 过短脉冲处理
        freqEst = 0;
        return;
    end
    
    % 矩形窗STFT
    rectWin = ones(1, N);
    Nfft = 2^nextpow2(8*N); % 8倍补零提高分辨率
    stft = fft(pulseData .* rectWin, Nfft);
    magSpec = abs(stft(1:Nfft/2+1));
    
    % 寻找主峰位置
    [~, idx] = max(magSpec);
    freqEst = (idx-1) * fs / Nfft;
    
    % 二次插值提高精度
    if idx > 1 && idx < length(magSpec)
        y0 = magSpec(idx-1);
        y1 = magSpec(idx);
        y2 = magSpec(idx+1);
        delta = 0.5*(y0 - y2)/(y0 - 2*y1 + y2);
        freqEst = (idx-1 + delta) * fs / Nfft;
    end
end
