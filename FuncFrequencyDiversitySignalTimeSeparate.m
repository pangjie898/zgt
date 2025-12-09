function [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncFrequencyDiversitySignalTimeSeparate(FrequencyDiversityNum,SamplingFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseWidth,FrequencyDiversityTimeInterval,FrequencyDiversityFrequencyNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle)
%% 函数功能：产生频率分集（分时）信号
%    输入：
%           FrequencyDiversityNum：频率分集数目
%               SamplingFrequency：采样频率；
%                         PriType：重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）；
%                             Pri：脉冲重复周期；
%        PulseGroupUnevenGroupNum：重频类型为脉组参差时参差的组数；
% PulseGroupUnevenPulseNumInGroup：重频类型为脉组参差时组内脉冲数目；
%          OneTimeSlidingMaxRange：重频类型为滑变时的滑变一次的最大滑变范围；
%      SawtoothSlidingNumOneCycle：重频类型为滑变时锯齿滑变周期内滑变次数；
%      TriangleSlidingNumOneCycle：重频类型为滑变时三角滑变周期内滑变次数；
%          SineSlidingNumOneCycle：重频类型为滑变时正弦滑变周期内滑变次数；
%                      PulseWidth：脉冲宽度；
%  FrequencyDiversityTimeInterval：分集信号分时间隔；
%  FrequencyDiversityFrequencyNum：分集频率；
%             PulseUnevenPulseNum：重频类型为脉间参差时参差脉冲数；
%                  PulseUnevenPri：重频类型为脉间参差时参差Pri；
%             PulseGroupUnevenPri：重频类型为脉组参差时参差Pri；
%                JitterPercentage：重频类型为抖动时抖动百分比；
%            AntennaScanningCycle：天线扫描周期；
%    输出：
%            SignalExecptFirstToa：频率分集（分时）信号；
%%
% FirstPulseToa=3*rand(1,1)*Pri;
RoundFirstPulseToa=roundn(FirstPulseToa,-6);
FirstPulseTime=0:1/SamplingFrequency:(RoundFirstPulseToa-1/SamplingFrequency);%第一个脉冲到达时间，赋值0
FirstPulseArray(1:length(FirstPulseTime))=0;%第一个脉冲到达时间数组，赋值0
SignalCell=[];
FrequencyDiversityTimeIntervalSampling=0:1/SamplingFrequency:FrequencyDiversityTimeInterval-1/SamplingFrequency;
TimeIntervalZeroArray=0*FrequencyDiversityTimeIntervalSampling;
switch PriType
    case 1 %重频固定
        PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);%脉冲宽度，赋值1
        PriEcexptPulse=0:1/SamplingFrequency:Pri-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
        PulseArray(1:length(PulseTime))=1;%脉冲宽度内窗高1
        for i=1:length(PriEcexptPulse)%Pri出去脉宽，其余部分窗高0
            PulseArray=[PulseArray 0];
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,Pri)==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=(AntennaScanningCycleNum*AntennaScanningCycle)/Pri;
        %%%%%%%%%%%%%%%%%%%% 生成完整信号Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for p=1:PriNum
            TotalPri(p)=Pri;
        end
        %%%%%%%%%%%%%%%%%%%% 生成完整信号矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalArray=[];
        for i=1:PriNum
            SignalArray=[SignalArray PulseArray];
        end
        %%%%%%%%%%%%%%%%%%%% 生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=PriNum*Pri;
        SignalSamplingTime=0:1/SamplingFrequency:SignalTime-1/SamplingFrequency;
        for i=1:FrequencyDiversityNum
            Frequency =  FrequencyDiversityFrequencyNum(i);
            SignalCell{i}=10*i*exp(2*j*pi*Frequency*SignalSamplingTime);
        end
        switch FrequencyDiversityNum
            case 1
                y=SignalCell{1};
            case 2
                x1=[SignalCell{1} TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2}];
                y=(x1+x2)/2;
            case 3
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3}];
                y=(x1+x2+x3)/3;
            case 4
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4}];
                y=(x1+x2+x3+x4)/4;
            case 5
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4} TimeIntervalZeroArray];
                x5=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{5}];
                y=(x1+x2+x3+x4+x5)/5;
        end
        FrequencyDiversitySignal=y;
        SignalCell=FrequencyDiversitySignal(1:length(SignalArray));
        SignalExecptFirstToa=SignalArray.*SignalCell;
    case 2 %重频参差 脉冲间
        %%%%%%%%%%%%%%%%%%%% 生成一段完整脉冲间参差Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        PulseTime= 0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);%脉冲宽度，赋值1
        for I=1:PulseUnevenPulseNum
            x1=PulseUnevenPri(I);
            PriEcexptPulse= 0:1/SamplingFrequency:x1-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
            PulseArray=[];
            PulseArray(1:length(PulseTime))=1;
            for i=1:length(PriEcexptPulse)
                PulseArray=[PulseArray 0];
            end
            PulseTotalArray{I}=PulseArray;
        end
        %%%%%%%%%%%%%%%%%%%% 一段完整脉冲间参差Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompletePriTime=0;
        for i=1:PulseUnevenPulseNum
            CompletePriTime=CompletePriTime+PulseUnevenPri(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,roundn(CompletePriTime,-6))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=PulseUnevenPulseNum*(AntennaScanningCycleNum*AntennaScanningCycle)/roundn(CompletePriTime,-6);
        PriNum=round(PriNum);
        SignalTime=CompletePriTime*PriNum/PulseUnevenPulseNum;
        %%%%%%%%%%%%%%%%%%%% 生成完整信号Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/PulseUnevenPulseNum
            for q=1:PulseUnevenPulseNum
                TotalPri(m)=PulseUnevenPri(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%% 生成完整信号矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalArray=[];
        m=1;
        for I=1:PriNum
            if (m>length(PulseTotalArray))
                m=1;
                SignalArray=[SignalArray PulseTotalArray{m}];
                m=m+1;
            else
                SignalArray=[SignalArray PulseTotalArray{m}];
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%% 生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalSamplingTime=0:1/SamplingFrequency:SignalTime-1/SamplingFrequency;
        for i=1:FrequencyDiversityNum
            Frequency =  FrequencyDiversityFrequencyNum(i);
            SignalCell{i}=10*i*exp(2*j*pi*Frequency*SignalSamplingTime);
        end
        switch FrequencyDiversityNum
            case 1
                y=SignalCell{1};
            case 2
                x1=[SignalCell{1} TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2}];
                y=(x1+x2)/2;
            case 3
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3}];
                y=(x1+x2+x3)/3;
            case 4
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4}];
                y=(x1+x2+x3+x4)/4;
            case 5
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4} TimeIntervalZeroArray];
                x5=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{5}];
                y=(x1+x2+x3+x4+x5)/5;
        end
        FrequencyDiversitySignal=y;
        SignalCell=FrequencyDiversitySignal(1:length(SignalArray));
        SignalExecptFirstToa=SignalArray.*SignalCell;
    case 3 %重频参差 脉组间
        %%%%%%%%%%%%%%%%%组内脉冲间矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        PulseTime= 0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);%脉冲宽度，赋值1
        %%%%%%%%%%%%%%%%%多个组矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalArray=[];
        m=1;
        for JTemporary=1:PulseGroupUnevenGroupNum    % PulseGroupUnevenGroupNum 为组数
            x2=PulseGroupUnevenPri(JTemporary); %参差组间距
            ZeroArraySamplingTime= 0:1/SamplingFrequency:x2-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
            PulseArray=[];
            PulseArray(1:length(PulseTime))=1;
            for i=1:length(ZeroArraySamplingTime)
                PulseArray=[PulseArray 0];
            end
            for JTemporary=1:PulseGroupUnevenPulseNumInGroup    % M 为一个组内的脉冲数
                SignalArray{m}=PulseArray;
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%% 一段完整的组间参差信号周期%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompletePriTime=0;
        for i=1:PulseGroupUnevenGroupNum
            CompletePriTime=CompletePriTime+PulseGroupUnevenPulseNumInGroup*PulseGroupUnevenPri(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,roundn(CompletePriTime,-6))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup*(AntennaScanningCycleNum*AntennaScanningCycle)/roundn(CompletePriTime,-6);
        PriNum=round(PriNum);
        %%%%%%%%%%%%%%%%%%%% 生成一段完整组间参差Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PulseGroupUnevenGroupNum    % PulseGroupUnevenGroupNum 为组数
            for q=1:PulseGroupUnevenPulseNumInGroup
                TotalUnevenPri(m)=PulseGroupUnevenPri(p); %参差组间距
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%% 生成完整信号Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/(PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup)
            for q=1:length(TotalUnevenPri)
                TotalPri(m)=TotalUnevenPri(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%% 生成完整信号矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSignalArray=[];
        for i=1:length(SignalArray)
            CompleteSignalArray=[CompleteSignalArray SignalArray{i}];
        end
        CompleteSignalArray=repmat(CompleteSignalArray,1,PriNum/(PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup));
        %%%%%%%%%%%%%%%%%%%% 生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompletePriTime*PriNum/(PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup);
        SignalSamplingTime= 0:1/SamplingFrequency:(SignalTime-1/SamplingFrequency);
        for i=1:FrequencyDiversityNum
            Frequency =  FrequencyDiversityFrequencyNum(i);
            SignalCell{i}=10*i*exp(2*j*pi*Frequency*SignalSamplingTime);
        end
        switch FrequencyDiversityNum
            case 1
                y=SignalCell{1};
            case 2
                x1=[SignalCell{1} TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2}];
                y=(x1+x2)/2;
            case 3
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3}];
                y=(x1+x2+x3)/3;
            case 4
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4}];
                y=(x1+x2+x3+x4)/4;
            case 5
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4} TimeIntervalZeroArray];
                x5=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{5}];
                y=(x1+x2+x3+x4+x5)/5;
        end
        FrequencyDiversitySignal=y;
        SignalArray=CompleteSignalArray;
        SignalCell=FrequencyDiversitySignal(1:length(SignalArray));
        SignalExecptFirstToa=SignalArray.*SignalCell;
    case 4 %重频抖动
        CenterPri=Pri;%频率抖动中心值
        PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);
        %%%%%%%%%%%%%%%%%生成若干个抖动Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:100000
            temp=-1+(1-(-1))*rand(1,1);%产生一个-1到1的随机数
            JitterPri(i)=CenterPri*(1+JitterPercentage/100*temp);
            RoundJitterPri(i)=roundn(JitterPri(i),-6);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        n=ceil(2*JitterPercentage/100*CenterPri/1e-6)+1;
        JTemporary=1;
        JHTemporary={};
        AntennaScanningSamplingCycle=0:1/SamplingFrequency:AntennaScanningCycle-1/SamplingFrequency;
        for JTemporary=n:length(RoundJitterPri)
            TotalPri=sum(RoundJitterPri(1:JTemporary));
            CompletePriTime=TotalPri;
            CompletePriSamplingTime=0:1/SamplingFrequency:CompletePriTime-1/SamplingFrequency;
            for i=1:100000
                if(mod(i*length(AntennaScanningSamplingCycle),length(CompletePriSamplingTime))==0)
                    JHTemporary=i;
                    break;
                end
            end
            if(mod(i*length(AntennaScanningSamplingCycle),length(CompletePriSamplingTime))==0)
                JHTemporary=i;
                break;
            end
        end
        AntennaScanningCycleNum=JHTemporary;
        PriNum=round(JTemporary)*(AntennaScanningCycleNum*AntennaScanningCycle)/TotalPri;
        PriNum=round(PriNum);
        %%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/round(JTemporary)
            for q=1:round(JTemporary)
                TotalPri(m)=RoundJitterPri(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%生成完整信号的矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for I=1:JTemporary
            PriEcexptPulse= 0:1/SamplingFrequency:RoundJitterPri(I)-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
            PulseArray=[];
            PulseArray(1:length(PulseTime))=1;
            for i=1:length(PriEcexptPulse)
                PulseArray=[PulseArray 0];
            end
            JitterPriArray{I}=PulseArray;
        end
        SignalArray=[];
        for i=1:length(JitterPriArray)
            SignalArray=[SignalArray JitterPriArray{i}];
        end
        CompleteSignalArray=[];
        CompleteSignalArray=repmat(SignalArray,1,PriNum/JTemporary);
        %%%%%%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=PriNum/round(JTemporary)*TotalPri;
        SignalSamplingTime= 0:1/SamplingFrequency:(SignalTime-1/SamplingFrequency);
        for i=1:FrequencyDiversityNum
            Frequency =  FrequencyDiversityFrequencyNum(i);
            SignalCell{i}=10*i*exp(2*j*pi*Frequency*SignalSamplingTime);
        end
        switch FrequencyDiversityNum
            case 1
                y=SignalCell{1};
            case 2
                x1=[SignalCell{1} TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2}];
                y=(x1+x2)/2;
            case 3
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3}];
                y=(x1+x2+x3)/3;
            case 4
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4}];
                y=(x1+x2+x3+x4)/4;
            case 5
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4} TimeIntervalZeroArray];
                x5=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{5}];
                y=(x1+x2+x3+x4+x5)/5;
        end
        FrequencyDiversitySignal=y;
        SignalArray=CompleteSignalArray;
        SignalCell=FrequencyDiversitySignal(1:length(SignalArray));
        SignalExecptFirstToa=SignalArray.*SignalCell;
    case 5 % 重频滑变 锯齿形状
        PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);
        CenterPri=Pri;%频率滑变初始值
        %%%%%%%%%%%%%%%%%生成一段完整的滑动窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for I=1:SawtoothSlidingNumOneCycle
            EachSlidingPriTime(I)=roundn(CenterPri+I*OneTimeSlidingMaxRange/SawtoothSlidingNumOneCycle,-6);
            PriEcexptPulse= 0:1/SamplingFrequency:EachSlidingPriTime(I)-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
            PulseArray=[];
            PulseArray(1:length(PulseTime))=1;
            for i=1:length(PriEcexptPulse)
                PulseArray=[PulseArray 0];
            end
            SlidingPriArray{I}=PulseArray;
        end
        %%%%%%%%%%%%%%%%%%%%%%%% 一段完整的滑动信号周期%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompletePriTime=0;
        for i=1:SawtoothSlidingNumOneCycle
            CompletePriTime=CompletePriTime+EachSlidingPriTime(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,roundn(CompletePriTime,-6))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=SawtoothSlidingNumOneCycle*(AntennaScanningCycleNum*AntennaScanningCycle)/roundn(CompletePriTime,-6);
        PriNum=round(PriNum);
        %%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/SawtoothSlidingNumOneCycle
            for q=1:SawtoothSlidingNumOneCycle
                TotalPri(m)=EachSlidingPriTime(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%生成完整信号的矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSignalArray=[];
        for i=1:length(SlidingPriArray)
            CompleteSignalArray=[CompleteSignalArray SlidingPriArray{i}];
        end
        CompleteSignalArray=repmat(CompleteSignalArray,1,PriNum/(SawtoothSlidingNumOneCycle));
        %%%%%%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompletePriTime*PriNum/(SawtoothSlidingNumOneCycle);
        SignalSamplingTime= 0:1/SamplingFrequency:(SignalTime-1/SamplingFrequency);
        for i=1:FrequencyDiversityNum
            Frequency =  FrequencyDiversityFrequencyNum(i);
            SignalCell{i}=10*i*exp(2*j*pi*Frequency*SignalSamplingTime);
        end
        switch FrequencyDiversityNum
            case 1
                y=SignalCell{1};
            case 2
                x1=[SignalCell{1} TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2}];
                y=(x1+x2)/2;
            case 3
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3}];
                y=(x1+x2+x3)/3;
            case 4
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4}];
                y=(x1+x2+x3+x4)/4;
            case 5
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4} TimeIntervalZeroArray];
                x5=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{5}];
                y=(x1+x2+x3+x4+x5)/5;
        end
        FrequencyDiversitySignal=y;
        SignalArray=CompleteSignalArray;
        SignalCell=FrequencyDiversitySignal(1:length(SignalArray));
        SignalExecptFirstToa=SignalArray.*SignalCell;
    case 6 % 重频滑变 三角形状
        PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);
        CenterPri=Pri;%频率滑变初始值
        %%%%%%%%%%%%%%%%%生成一段完整的滑动窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        EachSlidingTime=roundn(OneTimeSlidingMaxRange/TriangleSlidingNumOneCycle,-6);
        for I=1:TriangleSlidingNumOneCycle%S为奇数
            if I<=(TriangleSlidingNumOneCycle+1)/2
                EachSlidingPriTime(I)=CenterPri+I*EachSlidingTime;
            else
                EachSlidingPriTime(I)=CenterPri+(TriangleSlidingNumOneCycle-I+1)*EachSlidingTime;
            end
            PriEcexptPulse= 0:1/SamplingFrequency:EachSlidingPriTime(I)-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
            PulseArray=[];
            PulseArray(1:length(PulseTime))=1;
            for i=1:length(PriEcexptPulse)
                PulseArray=[PulseArray 0];
            end
            SlidingPriArray{I}=PulseArray;
        end
        %%%%%%%%%%%%%%%%%%%%%%%% 一段完整的滑动信号周期%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompletePriTime=0;
        for i=1:TriangleSlidingNumOneCycle
            CompletePriTime=CompletePriTime+EachSlidingPriTime(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,(roundn(CompletePriTime,-6)))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=TriangleSlidingNumOneCycle*(AntennaScanningCycleNum*AntennaScanningCycle)/(roundn(CompletePriTime,-6));
        PriNum=round(PriNum);
        %%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/TriangleSlidingNumOneCycle
            for q=1:TriangleSlidingNumOneCycle
                TotalPri(m)=EachSlidingPriTime(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%生成完整信号的矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSignalArray=[];
        for i=1:length(SlidingPriArray)
            CompleteSignalArray=[CompleteSignalArray SlidingPriArray{i}];
        end
        CompleteSignalArray=repmat(CompleteSignalArray,1,PriNum/(TriangleSlidingNumOneCycle));
        %%%%%%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompletePriTime*PriNum/(TriangleSlidingNumOneCycle);
        SignalSamplingTime= 0:1/SamplingFrequency:(SignalTime-1/SamplingFrequency);
        for i=1:FrequencyDiversityNum
            Frequency =  FrequencyDiversityFrequencyNum(i);
            SignalCell{i}=10*i*exp(2*j*pi*Frequency*SignalSamplingTime);
        end
        switch FrequencyDiversityNum
            case 1
                y=SignalCell{1};
            case 2
                x1=[SignalCell{1} TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2}];
                y=(x1+x2)/2;
            case 3
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3}];
                y=(x1+x2+x3)/3;
            case 4
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4}];
                y=(x1+x2+x3+x4)/4;
            case 5
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4} TimeIntervalZeroArray];
                x5=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{5}];
                y=(x1+x2+x3+x4+x5)/5;
        end
        FrequencyDiversitySignal=y;
        SignalArray=CompleteSignalArray;
        SignalCell=FrequencyDiversitySignal(1:length(SignalArray));
        SignalExecptFirstToa=SignalArray.*SignalCell;
    case 7 % 重频滑变 正弦函数
        PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);
        CenterPri=Pri;%频率滑变初始值
        %%%%%%%%%%%%%%%%%生成一段完整的滑动窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for I=1:SineSlidingNumOneCycle
            SlidingPri(I)=CenterPri+OneTimeSlidingMaxRange*sin(I*pi/(2*SineSlidingNumOneCycle));
            RoundSlidingPri=roundn(SlidingPri(I),-6);
            EachSlidingPriTime(I)=RoundSlidingPri;
            PriEcexptPulse= 0:1/SamplingFrequency:EachSlidingPriTime(I)-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
            PulseArray=[];
            PulseArray(1:length(PulseTime))=1;
            for i=1:length(PriEcexptPulse)
                PulseArray=[PulseArray 0];
            end
            SlidingPriArray{I}=PulseArray;
        end
        %%%%%%%%%%%%%%%%%%%%%%%% 一段完整的滑动信号周期%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompletePriTime=0;
        for i=1:SineSlidingNumOneCycle
            CompletePriTime=CompletePriTime+EachSlidingPriTime(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        AntennaScanningCycle=0:1/SamplingFrequency:AntennaScanningCycle-1/SamplingFrequency;
        CompletePriSamplingTime=0:1/SamplingFrequency:CompletePriTime-1/SamplingFrequency;
        for i=1:100000
            if(mod(i*length(AntennaScanningCycle),length(CompletePriSamplingTime))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=SineSlidingNumOneCycle*(AntennaScanningCycleNum*length(AntennaScanningCycle))/length(CompletePriSamplingTime);
        PriNum=round(PriNum);
        %%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/SineSlidingNumOneCycle
            for q=1:SineSlidingNumOneCycle
                TotalPri(m)=EachSlidingPriTime(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%生成完整信号的矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSignalArray=[];
        for i=1:length(SlidingPriArray)
            CompleteSignalArray=[CompleteSignalArray SlidingPriArray{i}];
        end
        CompleteSignalArray=repmat(CompleteSignalArray,1,PriNum/(SineSlidingNumOneCycle));
        %%%%%%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompletePriTime*PriNum/(SineSlidingNumOneCycle);
        SignalSamplingTime= 0:1/SamplingFrequency:(SignalTime-1/SamplingFrequency);
        for i=1:FrequencyDiversityNum
            Frequency =  FrequencyDiversityFrequencyNum(i);
            SignalCell{i}=10*i*exp(2*j*pi*Frequency* SignalSamplingTime);
        end
        switch FrequencyDiversityNum
            case 1
                y=SignalCell{1};
            case 2
                x1=[SignalCell{1} TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2}];
                y=(x1+x2)/2;
            case 3
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3}];
                y=(x1+x2+x3)/3;
            case 4
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4}];
                y=(x1+x2+x3+x4)/4;
            case 5
                x1=[SignalCell{1} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x2=[TimeIntervalZeroArray SignalCell{2} TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray];
                x3=[TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{3} TimeIntervalZeroArray TimeIntervalZeroArray];
                x4=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{4} TimeIntervalZeroArray];
                x5=[TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray TimeIntervalZeroArray SignalCell{5}];
                y=(x1+x2+x3+x4+x5)/5;
        end
        FrequencyDiversitySignal=y;
        SignalArray=CompleteSignalArray;
        SignalCell=FrequencyDiversitySignal(1:length(SignalArray));
        SignalExecptFirstToa=SignalArray.*SignalCell;
end


