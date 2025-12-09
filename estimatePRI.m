function priEst = estimatePRI(toaEst, fs, priRatioThreshold)
    if numel(toaEst) < 3
        priEst = [];
        return;
    end
    
    priIntervals = diff(toaEst);
    meanPRI = mean(priIntervals);
    absDiffs = abs(priIntervals - meanPRI);
    normRatios = absDiffs / meanPRI;
    
    % 阈值筛选
    validPris = priIntervals(normRatios < priRatioThreshold);
    
    if ~isempty(validPris)
        priEst = mean(validPris);
    else
        priEst = meanPRI;
    end
end