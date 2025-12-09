function [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncRapidFrequencySignalPulse(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,RapidFrequencyRange,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,SawtoothSlidingNumOneCycle,OneTimeSlidingMaxRange,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,RapidFrequencyPointNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle)
%% 函数功能：产生脉间捷变频信号
%    输入：
%                       PulseWidth：脉冲宽度；
%                SamplingFrequency：采样频率；
%                        Amplitude：信号幅度；
%                 CarrierFrequency：信号载频；
%                 PriType：重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）；
%                              Pri：脉冲重复周期；
%              RapidFrequencyRange：捷变范围；
%         PulseGroupUnevenGroupNum：重频类型为脉组参差时参差的组数；
%  PulseGroupUnevenPulseNumInGroup：重频类型为脉组参差时组内脉冲数目；
%       SawtoothSlidingNumOneCycle：重频类型为滑变时锯齿滑变周期内滑变次数；
%           OneTimeSlidingMaxRange：重频类型为滑变时的滑变一次的最大滑变范围；
%       TriangleSlidingNumOneCycle：重频类型为滑变时三角滑变周期内滑变次数；
%           SineSlidingNumOneCycle：重频类型为滑变时正弦滑变周期内滑变次数；
%           RapidFrequencyPointNum：捷变点数；
%              PulseUnevenPulseNum：重频类型为脉间参差时参差脉冲数；
%                   PulseUnevenPri：重频类型为脉间参差时参差Pri；
%              PulseGroupUnevenPri：重频类型为脉组参差时参差Pri；
%                 JitterPercentage：重频类型为抖动时抖动百分比；
%             AntennaScanningCycle：天线扫描周期；
%    输出：
%             SignalExecptFirstToa：脉间捷变频信号；
%%
% FirstPulseToa=rand(1,1)*Pri;
RoundFirstPulseToa=roundn(FirstPulseToa,-6);
FirstPulseTime=0:1/SamplingFrequency:(RoundFirstPulseToa-1/SamplingFrequency);%第一个脉冲到达时间，赋值0
FirstPulseArray(1:length(FirstPulseTime))=0;%第一个脉冲到达时间数组，赋值0
PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);
switch PriType
    case 1 %重频固定
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
        %%%%%%%%%%%%%%%%%%%% 生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=PriNum*Pri;
        ZeroArraySamplingTime=0:1/SamplingFrequency:(Pri-PulseWidth)-1/SamplingFrequency;
        ZeroArray=0*ZeroArraySamplingTime;
        SignalExecptFirstToa=[];
        for i=1:PriNum
            temp=randi([-(RapidFrequencyPointNum-1),(RapidFrequencyPointNum-1)],1,1);%产生一个-(M-1)到(M-1)的随机数
            RapidFrequency(i)=CarrierFrequency+RapidFrequencyRange/2/(RapidFrequencyPointNum)*temp;
            RoundRapidFrequency(i)=roundn(RapidFrequency(i),6);
            RapidFrequencySignal=Amplitude*exp(2*j*pi*RoundRapidFrequency(i)*PulseTime);
            SignalExecptFirstToa=[SignalExecptFirstToa RapidFrequencySignal ZeroArray];
        end
    case 2  %重频参差 脉冲间
        %%%%%%%%%%%%%%%%%%%% 一段完整脉冲间参差Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSectionPri=0;
        for i=1:PulseUnevenPulseNum
            CompleteSectionPri=CompleteSectionPri+PulseUnevenPri(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,roundn(CompleteSectionPri,-6))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=PulseUnevenPulseNum*(AntennaScanningCycleNum*AntennaScanningCycle)/roundn(CompleteSectionPri,-6);
        PriNum=round(PriNum);
        SignalTime=CompleteSectionPri*PriNum/PulseUnevenPulseNum;
        %%%%%%%%%%%%%%%%%%%% 生成完整信号Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/PulseUnevenPulseNum
            for q=1:PulseUnevenPulseNum
                TotalPri(m)=PulseUnevenPri(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:PriNum
            temp=randi([-(RapidFrequencyPointNum-1),(RapidFrequencyPointNum-1)],1,1);%产生一个-(M-1)到(M-1)的随机数
            RapidFrequency(i)=CarrierFrequency+RapidFrequencyRange/2/(RapidFrequencyPointNum)*temp;
            RoundRapidFrequency(i)=roundn(RapidFrequency(i),6);
            RapidFrequencySignal{i}=Amplitude*exp(2*j*pi*RoundRapidFrequency(i)*PulseTime);
        end
        %%%%%%%%%%%%%%%%%%%信号加参差Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        while(m<=PriNum)
            for JTemporary=1:PulseUnevenPulseNum
                if(m<=PriNum)
                    ZeroArraySamplingTime=0:1/SamplingFrequency:(PulseUnevenPri(JTemporary)-PulseWidth)-1/SamplingFrequency;
                    ZeroArray=0*ZeroArraySamplingTime;
                    TemporarySignal=[RapidFrequencySignal{m} ZeroArray];
                    SignalExecptFirstToa{m}=TemporarySignal;
                    m=m+1;
                end
            end
        end
        SignalArray=[];
        for i=1:PriNum
            SignalArray=[SignalArray SignalExecptFirstToa{i}];
        end
        SignalExecptFirstToa=SignalArray;
    case 3 %重频参差 脉组间
        %%%%%%%%%%%%%%%%%%%%%%%% 一段完整的组间参差信号周期%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSectionPri=0;
        for i=1:PulseGroupUnevenGroupNum
            CompleteSectionPri=CompleteSectionPri+PulseGroupUnevenPulseNumInGroup*PulseGroupUnevenPri(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,roundn(CompleteSectionPri,-6))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup*(AntennaScanningCycleNum*AntennaScanningCycle)/roundn(CompleteSectionPri,-6);
        PriNum=round(PriNum);
        %%%%%%%%%%%%%%%%%%%% 生成一段完整组间参差Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PulseGroupUnevenGroupNum    % N_PulseUnevenPulseNum 为组数
            for q=1:PulseGroupUnevenPulseNumInGroup
                CompleteSectionPri(m)=PulseGroupUnevenPri(p); %参差组间距
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%% 生成完整信号Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/(PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup)
            for q=1:length(CompleteSectionPri)
                TotalPri(m)=CompleteSectionPri(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompleteSectionPri*PriNum/(PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup);
        for i=1:PriNum
            temp=randi([-(RapidFrequencyPointNum-1),(RapidFrequencyPointNum-1)],1,1);%产生一个-(M-1)到(M-1)的随机数
            RapidFrequency(i)=CarrierFrequency+RapidFrequencyRange/2/(RapidFrequencyPointNum)*temp;
            RoundRapidFrequency(i)=roundn(RapidFrequency(i),6);
            RapidFrequencySignal{i}=Amplitude*exp(2*j*pi*RoundRapidFrequency(i)*PulseTime);
        end
        %%%%%%%%%%%%%%%%%%%信号加参差Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalExecptFirstToa=[];
        m=1;
        while(m<=PriNum)
            for JTemporary=1:PulseGroupUnevenGroupNum % N_PulseUnevenPulseNum 为组数
                UnevenPri=PulseGroupUnevenPri(JTemporary); %参差组间距
                ZeroArraySamplingTime=0:1/SamplingFrequency:(UnevenPri-PulseWidth)-1/SamplingFrequency;
                ZeroArray=0*ZeroArraySamplingTime;
                for i=1:PulseGroupUnevenPulseNumInGroup
                    if(m<=PriNum)
                        TemporarySignal=[RapidFrequencySignal{m} ZeroArray];
                        RapidFrequencySignal{m}=TemporarySignal;
                        m=m+1;
                    end
                end
            end
        end
        SignalArray=[];
        for i=1:PriNum
            SignalArray=[SignalArray RapidFrequencySignal{i}];
        end
        SignalExecptFirstToa=SignalArray;
    case 4%重频抖动
        CenterPri=Pri;%频率抖动中心值
        SignalExecptFirstToa=[];
        %%%%%%%%%%%%%%%%%%%生成大量抖动Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:100000
            temp=-1+(1-(-1))*rand(1,1);%产生一个-1到1的随机数
            JitterPri(i)=CenterPri*(1+JitterPercentage/100*temp);
            RoundJitterPri(i)=roundn(JitterPri(i),-6);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期确定抖动Pri数目%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        n=ceil(2*JitterPercentage/100*CenterPri/1e-6)+1;
        JTemporary=1;
        AntennaScanningSamplingCycle=0:1/SamplingFrequency:AntennaScanningCycle-1/SamplingFrequency;
        for JTemporary=n:length(RoundJitterPri)
            TotalPri=sum(RoundJitterPri(1:JTemporary));
            CompleteSectionPri=TotalPri;
            CompletePriSamplingTime=0:1/SamplingFrequency:CompleteSectionPri-1/SamplingFrequency;
            for i=1:100000
                if(mod(i*length(AntennaScanningSamplingCycle),length(CompletePriSamplingTime))==0)
                    JHTemporary=i;
                    break;
                end
                
            end
            if(mod(i*length(AntennaScanningSamplingCycle),length(CompletePriSamplingTime))==0)
                JHTemporary=i;
            end
            break;
        end
        AntennaScanningCycleNum=JHTemporary;
        PriNum=JTemporary*(AntennaScanningCycleNum*AntennaScanningCycle)/TotalPri;
        PriNum=round(PriNum);
        SignalTime=PriNum/round(JTemporary)*TotalPri;
        %%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/round(JTemporary)
            for q=1:round(JTemporary)TotalSignalNum
                TotalPri(m)=RoundJitterPri(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:PriNum
            temp=randi([-(RapidFrequencyPointNum-1),(RapidFrequencyPointNum-1)],1,1);%产生一个-(M-1)到(M-1)的随机数
            RapidFrequency(i)=CarrierFrequency+RapidFrequencyRange/2/(RapidFrequencyPointNum)*temp;
            RoundRapidFrequency(i)=roundn(RapidFrequency(i),6);
            RapidFrequencySignal{i}=Amplitude*exp(2*j*pi*RoundRapidFrequency(i)*PulseTime);
        end
        %%%%%%%%%%%%%%%%%%%生成信号加Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        while(m<=PriNum)
            for I=1:JTemporary
                if(m<=PriNum)
                    ZeroArraySamplingTime=0:1/SamplingFrequency:(RoundJitterPri(I)-PulseWidth)-1/SamplingFrequency;
                    ZeroArray=0*ZeroArraySamplingTime;
                    SignalTemporary=[RapidFrequencySignal{m} ZeroArray];
                    RapidFrequencySignal{m}=SignalTemporary;
                    m=m+1;
                end
            end
        end
        TotalSignal=[];
        for i=1:PriNum
            TotalSignal=[TotalSignal RapidFrequencySignal{i}];
        end
        
        SignalExecptFirstToa=TotalSignal;
    case 5%重频滑变 锯齿形状
        CenterPri=Pri;%频率滑变初始值
        %%%%%%%%%%%%%%%%%%%%%%%%滑动Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for  I=1:SawtoothSlidingNumOneCycle
             EachSlidingPriTime(I)=roundn(CenterPri+I*OneTimeSlidingMaxRange/SawtoothSlidingNumOneCycle,-6);
        end
        %%%%%%%%%%%%%%%%%%%%%%%% 一段完整的滑动信号周期%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSectionPri=0;
        for i=1:SawtoothSlidingNumOneCycle
            CompleteSectionPri=CompleteSectionPri+EachSlidingPriTime(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,roundn(CompleteSectionPri,-6))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=SawtoothSlidingNumOneCycle*(AntennaScanningCycleNum*AntennaScanningCycle)/roundn(CompleteSectionPri,-6);
        PriNum=round(PriNum);
        SignalTime=CompleteSectionPri*PriNum/(SawtoothSlidingNumOneCycle);
        %%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/SawtoothSlidingNumOneCycle
            for q=1:SawtoothSlidingNumOneCycle
                TotalPri(m)=EachSlidingPriTime(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:PriNum
            temp=randi([-(RapidFrequencyPointNum-1),(RapidFrequencyPointNum-1)],1,1);%产生一个-(M-1)到(M-1)的随机数
            RapidFrequency(i)=CarrierFrequency+RapidFrequencyRange/2/(RapidFrequencyPointNum)*temp;
            RoundRapidFrequency(i)=roundn(RapidFrequency(i),6);
            RapidFrequencySignal{i}=Amplitude*exp(2*j*pi*RoundRapidFrequency(i)*PulseTime);
        end
        %%%%%%%%%%%%%%%%%%%生成信号加Pri%%%%%%%%%%%%%%%%%%%
        m=1;
        while(m<=PriNum)
            for JTemporary=1:SawtoothSlidingNumOneCycle
                if(m<=PriNum)
                    ZeroArraySamplingTime=0:1/SamplingFrequency:(EachSlidingPriTime(JTemporary)-PulseWidth)-1/SamplingFrequency;
                    ZeroArray=0*ZeroArraySamplingTime;
                    SignalTemporary=[RapidFrequencySignal{m} ZeroArray];
                    RapidFrequencySignal{m}=SignalTemporary;
                    m=m+1;
                end
            end
        end
        TotalSignal=[];
        for i=1:PriNum
            TotalSignal=[TotalSignal RapidFrequencySignal{i}];
        end
        SignalExecptFirstToa=TotalSignal;
    case 6%重频滑变 三角形状
        CenterPri=Pri;%频率滑变初始值
        %%%%%%%%%%%%%%%%%%%%%%%%滑动Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%
        EachSlidingTime=roundn(OneTimeSlidingMaxRange/TriangleSlidingNumOneCycle,-6);
        for I=1:TriangleSlidingNumOneCycle%S为奇数
            if I<=(TriangleSlidingNumOneCycle+1)/2
                EachSlidingPriTime(I)=CenterPri+I*EachSlidingTime;
            else
                EachSlidingPriTime(I)=CenterPri+(TriangleSlidingNumOneCycle-I+1)*EachSlidingTime;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%% 一段完整的滑动信号周期%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSectionPri=0;
        for i=1:TriangleSlidingNumOneCycle
            CompleteSectionPri=CompleteSectionPri+EachSlidingPriTime(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,(roundn(CompleteSectionPri,-6)))==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=TriangleSlidingNumOneCycle*(AntennaScanningCycleNum*AntennaScanningCycle)/(roundn(CompleteSectionPri,-6));
        PriNum=round(PriNum);
        SignalTime=CompleteSectionPri*PriNum/(TriangleSlidingNumOneCycle);
        %%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/TriangleSlidingNumOneCycle
            for q=1:TriangleSlidingNumOneCycle
                TotalPri(m)=EachSlidingPriTime(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:PriNum
            temp=randi([-(RapidFrequencyPointNum-1),(RapidFrequencyPointNum-1)],1,1);%产生一个-(M-1)到(M-1)的随机数
            RapidFrequency(i)=CarrierFrequency+RapidFrequencyRange/2/(RapidFrequencyPointNum)*temp;
            RoundRapidFrequency(i)=roundn(RapidFrequency(i),6);
            RapidFrequencySignal{i}=Amplitude*exp(2*j*pi*RoundRapidFrequency(i)*PulseTime);
        end
        m=1;
        while(m<=PriNum)
            for JTemporary=1:TriangleSlidingNumOneCycle
                if(m<=PriNum)
                    ZeroArraySamplingTime=0:1/SamplingFrequency:(EachSlidingPriTime(JTemporary)-PulseWidth)-1/SamplingFrequency;
                    ZeroArray=0*ZeroArraySamplingTime;
                    TemporarySignal=[RapidFrequencySignal{m} ZeroArray];
                    RapidFrequencyTemporarySignal{m}=TemporarySignal;
                    m=m+1;
                end
            end
        end
        TotalSignal=[];
        for i=1:PriNum
            TotalSignal=[TotalSignal RapidFrequencyTemporarySignal{i}];
        end
        SignalExecptFirstToa=TotalSignal;
    case 7%重频滑变 正弦形状
        CenterPri=Pri;%频率滑变初始值
        %%%%%%%%%%%%%%%%%%%%%%%%滑动Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for I=1:SineSlidingNumOneCycle
            SlidingPri(I)=CenterPri+OneTimeSlidingMaxRange*sin(I*pi/(2*SineSlidingNumOneCycle));
            RoundSlidingPri=roundn(SlidingPri(I),-6);
            EachSlidingPriTime(I)=RoundSlidingPri;
        end
        %%%%%%%%%%%%%%%%%%%%%%%% 一段完整的滑动信号周期%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CompleteSectionPri=0;
        for i=1:SineSlidingNumOneCycle
            CompleteSectionPri=CompleteSectionPri+EachSlidingPriTime(i);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        JTemporary=1;
        JHTemporary={};
        for i=1:100000
            if(mod(i*AntennaScanningCycle,CompleteSectionPri)==0)
                JHTemporary{JTemporary}=i;
                JTemporary=JTemporary+1;
            end
        end
        AntennaScanningCycleNum=JHTemporary{1};
        PriNum=SineSlidingNumOneCycle*(AntennaScanningCycleNum*AntennaScanningCycle)/CompleteSectionPri;
        PriNum=round(PriNum);
        
        SignalTime=CompleteSectionPri*PriNum/(SineSlidingNumOneCycle);
        %%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/SineSlidingNumOneCycle
            for q=1:SineSlidingNumOneCycle
                TotalPri(m)=EachSlidingPriTime(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:PriNum
            temp=randi([-(RapidFrequencyPointNum-1),(RapidFrequencyPointNum-1)],1,1);%产生一个-(M-1)到(M-1)的随机数
            RapidFrequency(i)=CarrierFrequency+RapidFrequencyRange/2/(RapidFrequencyPointNum)*temp;
            RoundRapidFrequency(i)=roundn(RapidFrequency(i),6);
            RapidFrequencySignal{i}=Amplitude*exp(2*j*pi*RoundRapidFrequency(i)*PulseTime);
        end
        m=1;
        while(m<=PriNum)
            for JTemporary=1:SineSlidingNumOneCycle
                if(m<=PriNum)
                    ZeroArraySamplingTime=0:1/SamplingFrequency:(EachSlidingPriTime(JTemporary)-PulseWidth)-1/SamplingFrequency;
                    ZeroArray=0*ZeroArraySamplingTime;
                    TemporarySignal=[RapidFrequencySignal{m} ZeroArray];
                    RapidFrequencyTemporarySignal{m}=TemporarySignal;
                    m=m+1;
                end
            end
        end
        TotalSignal=[];
        for i=1:PriNum
            TotalSignal=[TotalSignal RapidFrequencyTemporarySignal{i}];
        end
        SignalExecptFirstToa=TotalSignal;
end


