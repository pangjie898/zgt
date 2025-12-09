function [Signal, AntennaScanningCycleNum, RoundFirstPulseToa] = ...
    FuncSingleFrequencySignal(PulseWidth, fs, Amp, fc, PriType, Pri, ...
    FirstPulseToa, OneTimeSlidingMaxRange, PulseGroupUnevenPulseNumInGroup, ...
    PulseGroupUnevenGroupNum, SawtoothSlidingNumOneCycle, ...
    TriangleSlidingNumOneCycle, SineSlidingNumOneCycle, ...
    PulseUnevenPulseNum, PulseUnevenPri, PulseGroupUnevenPri, ...
    JitterPercentage, AntennaScanningCycle)
    
    % 精度设置
    RoundFirstPulseToa = round(FirstPulseToa * 1e6) / 1e6; % 微秒精度
    
    % 根据PRI类型生成PRI序列
    switch PriType
        case 1 % 固定重频
            PRIs = repmat(Pri, 1, ceil(AntennaScanningCycle/Pri));
            
        case 2 % 脉间参差
            PRIs = repmat(PulseUnevenPri, 1, ceil(AntennaScanningCycle/sum(PulseUnevenPri)));
            
        case 3 % 脉组参差
            groupPRIs = repelem(PulseGroupUnevenPri, PulseGroupUnevenPulseNumInGroup);
            PRIs = repmat(groupPRIs, 1, ceil(AntennaScanningCycle/sum(groupPRIs)));
            
        case 4 % 重频抖动
            n = ceil(2*JitterPercentage/100*Pri/1e-6) + 1;
            basePRIs = Pri * (1 + JitterPercentage/100 * (2*rand(1,n)-1));
            PRIs = repmat(basePRIs, 1, ceil(AntennaScanningCycle/sum(basePRIs)));
            
        case 5 % 锯齿滑变
            PRIs = linspace(Pri, Pri+OneTimeSlidingMaxRange, SawtoothSlidingNumOneCycle);
            PRIs = repmat(PRIs, 1, ceil(AntennaScanningCycle/sum(PRIs)));
            
        case 6 % 三角滑变
            half = ceil(TriangleSlidingNumOneCycle/2);
            PRIs = [linspace(Pri, Pri+OneTimeSlidingMaxRange, half), ...
                    linspace(Pri+OneTimeSlidingMaxRange, Pri, TriangleSlidingNumOneCycle-half)];
            PRIs = repmat(PRIs, 1, ceil(AntennaScanningCycle/sum(PRIs)));
            
        case 7 % 正弦滑变
            PRIs = Pri + OneTimeSlidingMaxRange * sin(linspace(0, pi, SineSlidingNumOneCycle));
            PRIs = repmat(PRIs, 1, ceil(AntennaScanningCycle/sum(PRIs)));
    end
    
    % 计算总采样点数
    totalTime = sum(PRIs);
    AntennaScanningCycleNum = ceil(totalTime / AntennaScanningCycle);
    totalSamples = round(totalTime * fs);
    
    % 预分配信号内存
    Signal = zeros(1, totalSamples);
    
    % 生成脉冲信号
    currentTime = RoundFirstPulseToa;
    for i = 1:length(PRIs)
        % 计算脉冲位置
        startSample = round(currentTime * fs) + 1;
        endSample = startSample + round(PulseWidth * fs) - 1;
        
        % 边界检查
        if endSample > totalSamples
            break;
        end
        
        % 生成脉冲（只在脉冲宽度内生成载波）
        t_pulse = (0:(endSample - startSample)) / fs;
        pulseSignal = Amp * exp(2j * pi * fc * t_pulse);
        Signal(startSample:endSample) = pulseSignal;
        
        % 更新下一个脉冲位置
        currentTime = currentTime + PRIs(i);
    end
end