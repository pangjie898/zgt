% ==================== 辅助函数 ====================
function [starts, ends] = findPulseSegments(mask, power, th, fs)
    % 寻找连续区域
    diffMask = diff([0, mask, 0]);
    starts = find(diffMask == 1);
    ends = find(diffMask == -1) - 1;
    
    % 边缘精化：确保脉冲边界在功率下降沿
    for i = 1:length(starts)
        % 向前搜索真实起始点
        searchStart = max(1, starts(i)-round(0.1e-6*fs));
        win = searchStart:starts(i);
        if ~isempty(win)
            crossPoints = find(power(win) < th*0.9, 1, 'last');
            if ~isempty(crossPoints)
                starts(i) = win(crossPoints) + 1;
            end
        end
        
        % 向后搜索真实结束点
        searchEnd = min(length(power), ends(i)+round(0.1e-6*fs));
        win = ends(i):searchEnd;
        if ~isempty(win)
            crossPoints = find(power(win) < th*0.9, 1, 'first');
            if ~isempty(crossPoints)
                ends(i) = win(crossPoints) - 1;
            end
        end
    end
    
    % 移除无效脉冲（太短）
    minSamples = round(0.05e-6*fs);
    pulseLengths = ends - starts;
    valid = pulseLengths >= minSamples;
    starts = starts(valid);
    ends = ends(valid);
    
    % 按起始时间排序
    [starts, idx] = sort(starts);
    ends = ends(idx);
end