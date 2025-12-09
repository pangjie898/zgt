function jamParams = calculateJammingParams(jamType, radarParam)
    switch jamType
        case 1 % 窄带瞄频干扰
            jamParams.CenterFreq = radarParam.Frequency;
            jamParams.Bandwidth = 20e6; 
            jamParams.Power = radarParam.Power + 20;
            
        case 4 % 梳状谱干扰
            numFreqs = 5;
            freqStep = 10e6;
            startFreq = radarParam.Frequency - (numFreqs-1)/2 * freqStep;
            jamParams.Frequencies = startFreq + (0:numFreqs-1)*freqStep;
            jamParams.Power = radarParam.Power + 20;
            
        case 5 % 灵巧噪声干扰
            jamParams.CenterFreq = radarParam.Frequency;
            jamParams.Bandwidth = 20e6;
            jamParams.Power = radarParam.Power + 15;
            
        case 8 % 距离速度联合拖引干扰
            maxDeltaR = 3e8 * radarParam.PulseWidth / 2;
            deltaR = 0.8 * maxDeltaR;
            deltaT = 2 * deltaR / 3e8;
            deltaV = 30;
            jamParams.DeltaR = deltaR;
            jamParams.DeltaT = deltaT;
            jamParams.DeltaV = deltaV;
            
        case 9 % 密集假目标复制干扰
            jamParams.CenterFreq = radarParam.Frequency;
            jamParams.Power = radarParam.Power + 10;
            jamParams.NumFalseTargets = 10;
            jamParams.Interval = 5;
            
        otherwise
            jamParams = struct();
    end
end
