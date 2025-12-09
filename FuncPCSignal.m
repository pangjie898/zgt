function [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncPCSignal(CarrierFrequency,SamplingFrequency,Amplitude,SubcodeWidth,PriType,CodeType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle)
%% 函数功能：产生相位编码信号
%    输入：
%                CarrierFrequency：信号载频；
%               SamplingFrequency：采样频率；
%                       Amplitude：信号幅度；
%                    SubcodeWidth：子码宽度；
%                         PriType：重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）；
%                        CodeType：相位编码信号编码类型：1，二相 2位巴克码；2，二相 3位巴克码；3，二相 4位巴克码；4，二相 5位巴克码；5，二相 7位巴克码；6，二相 11位巴克码；
%                                           7，二相 13位巴克码；8，二相 7位m序列；9，二相 31位m序列；10，二相 3位L序列；11，二相 7位L序列；12，二相 11位L序列；
%                                           13，二相 19位L序列；14，二相 23位L序列；15，二相 31位L序列；16，二相 自定义码型；17，四相 13位泰勒码；18，四相 自定义码型；
%                             Pri：脉冲重复周期；
%        PulseGroupUnevenGroupNum：重频类型为脉组参差时参差的组数；
% PulseGroupUnevenPulseNumInGroup：重频类型为脉组参差时组内脉冲数目；
%          OneTimeSlidingMaxRange：重频类型为滑变时的滑变一次的最大滑变范围；
%      SawtoothSlidingNumOneCycle：重频类型为滑变时锯齿滑变周期内滑变次数；
%      TriangleSlidingNumOneCycle：重频类型为滑变时三角滑变周期内滑变次数；
%          SineSlidingNumOneCycle：重频类型为滑变时正弦滑变周期内滑变次数；
%             PulseUnevenPulseNum：重频类型为脉间参差时参差脉冲数；
%                  PulseUnevenPri：重频类型为脉间参差时参差Pri；
%             PulseGroupUnevenPri：重频类型为脉组参差时参差Pri；
%                JitterPercentage：重频类型为抖动时抖动百分比；
%            AntennaScanningCycle：天线扫描周期；
%    输出：
%            SignalExecptFirstToa：相位编码信号；
%%
% FirstPulseToa=3*rand(1,1)*Pri;
RoundFirstPulseToa=roundn(FirstPulseToa,-6);
FirstPulseTime=0:1/SamplingFrequency:(RoundFirstPulseToa-1/SamplingFrequency);%第一个脉冲到达时间，赋值0
FirstPulseArray(1:length(FirstPulseTime))=0;%第一个脉冲到达时间数组，赋值0
ts =1/SamplingFrequency;
Ni = round(SamplingFrequency*SubcodeWidth);          % 子码序列长度
% phi = [3*pi/4 pi/4 pi/4 5*pi/4 7*pi/4 7*pi/4 5*pi/4 3*pi/4]; %跳变了五次
switch CodeType
    case 1%二相 2位巴克码
        phi =[1 1]*pi;
    case 2%二相 3位巴克码
        phi =[1 1 0]*pi;
    case 3%二相 4位巴克码
        phi =[1 1 1 0]*pi;
    case 4%二相 5位巴克码
        phi =[1 1 1 0 1]*pi;
    case 5%二相 7位巴克码
        phi =[1 1 1 0 0 1 0]*pi;
    case 6%二相 11位巴克码
        phi =[1 1 1 0 0 0 1 0 0 1 0]*pi;
    case 7%二相 13位巴克码
        phi =[1 1 1 1 1 0 0 1 1 0 1 0 1]*pi;
    case 8%二相 7位m序列
        phi =[0 0 1 0 1 1 1]*pi;
    case 9%二相 31位m序列
        phi =[0 0 0 0 1 0 1 1 1 0 0 1 0 1 1 1 0 0 1 0 1 1 1 0 0 1 0 1 1 1 0]*pi;
    case 10%二相 3位L序列
        phi =[1 0 0]*pi;
    case 11%二相 7位L序列
        phi =[1 1 0 1 0 0 0]*pi;
    case 12%二相 11位L序列
        phi =[1 0 1 1 1 0 0 0 1 0 0]*pi;
    case 13%二相 19位L序列
        phi =[1 0 0 1 1 1 1 0 1 0 1 0 0 0 0 1 1 0 0]*pi;
    case 14%二相 23位L序列
        phi =[1 1 1 1 0 1 0 1 1 0 0 1 1 0 0 1 0 1 0 0 0 0 0]*pi;
    case 15%二相 31位L序列
        phi =[1 1 0 1 1 0 1 1 1 1 0 0 0 1 0 1 0 1 1 1 0 0 0 0 1 0 0 1 0 0 0]*pi;
    case 16%自定义二相码型
        phi =[0 1 1 0 0 0 1 1 0 0 0 1 0]*pi;
    case 17%四相 13位泰勒码
        phi =[0 1 2 3 0 3 1 3 0 3 2 1 0]*pi/2;
    case 18%自定义四相码型
        phi =[0 3 1 0 0 2 1 3 1 3 2 1 0]*pi/2;
        
end
PulseWidth=length(phi)*SubcodeWidth;%脉冲宽度
PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);
SubcodeWidthSamplingTime=0:1/SamplingFrequency:SubcodeWidth-1/SamplingFrequency;
n=length(phi);
%pha=0;
PcSignal=zeros(1,length(PulseTime));
w0=0;
for i=1:n
    PcSignal(1,(i-1)*length(SubcodeWidthSamplingTime)+1:i*length(SubcodeWidthSamplingTime))=Amplitude*exp(2*j*pi*CarrierFrequency*SubcodeWidthSamplingTime+j*phi(i)+w0);
end

switch PriType
    case 1%重频固定
        PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);%脉冲宽度，赋值1
        PriEcexptPulse=0:1/SamplingFrequency:Pri-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
        FirstPulseTime=0:1/SamplingFrequency:Pri-1/SamplingFrequency;%Pri 除了脉冲，赋值0
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
        SignalNum=ceil(SignalTime/PulseWidth);
        PcSignalArray=[];
        for i=1:SignalNum
            PcSignalArray=[PcSignalArray PcSignal];
        end
        SignalExecptFirstToa=SignalArray.*PcSignalArray(1:length(SignalArray));
    case 2%重频参差 脉冲间
        %%%%%%%%%%%%%%%%%%%% 一段完整脉冲间参差Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        PulseTime= 0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);%脉冲宽度，赋值1
        for I=1:PulseUnevenPulseNum
            PulseUnevenTime=PulseUnevenPri(I);
            PriEcexptPulse= 0:1/SamplingFrequency:PulseUnevenTime-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
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
        for i=1:PulseUnevenPulseNum
            SignalArray=[SignalArray PulseTotalArray{i}];
        end
        SignalArray=repmat(SignalArray,1,PriNum/PulseUnevenPulseNum);
        %%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalNum=ceil(SignalTime/PulseWidth);
        PcSignalArray=[];
        for i=1:SignalNum
            PcSignalArray=[PcSignalArray PcSignal];
        end
        SignalExecptFirstToa=SignalArray.*PcSignalArray(1:length(SignalArray));
    case 3%重频参差 脉组间
        %%%%%%%%%%%%%%%%%组内脉冲间矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        PulseTime= 0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);%脉冲宽度，赋值1
        %%%%%%%%%%%%%%%%%多个组矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        PulseTotalArray=[];
        m=1;
        for JTemporary=1:PulseGroupUnevenGroupNum    % PulseGroupUnevenGroupNum 为组数
            TemporaryPri=PulseGroupUnevenPri(JTemporary); %参差组间距
            ZeroArraySamplingTime= 0:1/SamplingFrequency:TemporaryPri-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
            PulseArray=[];
            PulseArray(1:length(PulseTime))=1;
            for i=1:length(ZeroArraySamplingTime)
                PulseArray=[PulseArray 0];
            end
            for JTemporary=1:PulseGroupUnevenPulseNumInGroup    % M 为一个组内的脉冲数
                PulseTotalArray{m}=PulseArray;
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
        SignalArray=[];
        for i=1:length(PulseTotalArray)
            SignalArray=[SignalArray PulseTotalArray{i}];
        end
        SignalArray=repmat(SignalArray,1,PriNum/(PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup));
        %%%%%%%%%%%%%%%%%%%% 生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompletePriTime*PriNum/(PulseGroupUnevenGroupNum*PulseGroupUnevenPulseNumInGroup);
        SignalNum=ceil(SignalTime/PulseWidth);
        PcSignalArray=[];
        for i=1:SignalNum
            PcSignalArray=[PcSignalArray PcSignal];
        end
        SignalExecptFirstToa=SignalArray.*PcSignalArray(1:length(SignalArray));
    case 4%重频抖动
        CenterPri=Pri;%频率抖动中心值
        PulseTime=0:1/SamplingFrequency:(PulseWidth-1/SamplingFrequency);
        %%%%%%%%%%%%%%%%%%%%%%%%%%生成若干个抖动Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i=1:100000
            temp=-1+(1-(-1))*rand(1,1);%产生一个-1到1的随机数
            JitterPri(i)=CenterPri*(1+JitterPercentage/100*temp);
            RoundJitterPri(i)=roundn(JitterPri(i),-6);
        end
        %%%%%%%%%%%%%%%%%%%根据天线扫描周期算出一段滑动信号的数目%%%%%%%%%%%%%%%%%%%
        n=2*JitterPercentage/100*CenterPri/1e-6+1;
        JHTemporary={};
        AntennaScanningSamplingCycle=0:1/SamplingFrequency:AntennaScanningCycle-1/SamplingFrequency;
        for PulseNum=n:1:length(RoundJitterPri)
            TotalPri=sum(RoundJitterPri(1:round(PulseNum)));
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
        PriNum=round(PulseNum)*(AntennaScanningCycleNum*AntennaScanningCycle)/TotalPri;
        PriNum=round(PriNum);
        %%%%%%%%%%%%%%%%%%%%% 生成完整信号的Pri%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m=1;
        for p=1:PriNum/round(PulseNum)
            for q=1:round(PulseNum)
                TotalPri(m)=RoundJitterPri(q);
                m=m+1;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%生成完整信号的矩形窗%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for I=1:round(PulseNum)
            PriEcexptPulse= 0:1/SamplingFrequency:RoundJitterPri(I)-PulseWidth-1/SamplingFrequency;%Pri 除了脉冲，赋值0
            PulseArray=[];
            PulseArray(1:length(PulseTime))=1;
            for i=1:length(PriEcexptPulse)
                PulseArray=[PulseArray 0];
            end
            JitterPriArray{I}=PulseArray;
        end
        PulseTotalArray=[];
        for i=1:length(JitterPriArray)
            PulseTotalArray=[PulseTotalArray JitterPriArray{i}];
        end
        SignalArray=[];
        SignalArray=repmat(PulseTotalArray,1,PriNum/round(PulseNum));
        %%%%%%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=PriNum/round(PulseNum)*TotalPri;
        SignalNum=ceil(SignalTime/PulseWidth);
        PcSignalArray=[];
        for i=1:SignalNum
            PcSignalArray=[PcSignalArray PcSignal];
        end
        SignalExecptFirstToa=SignalArray.*PcSignalArray(1:length(SignalArray));
    case 5%重频滑变 锯齿形状
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
            JitterPriArray{I}=PulseArray;
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
        SignalArray=[];
        for i=1:length(JitterPriArray)
            SignalArray=[SignalArray JitterPriArray{i}];
        end
        SignalArray=repmat(SignalArray,1,PriNum/(SawtoothSlidingNumOneCycle));
        %%%%%%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompletePriTime*PriNum/(SawtoothSlidingNumOneCycle);
        SignalNum=ceil(SignalTime/PulseWidth);
        PcSignalArray=[];
        for i=1:SignalNum
            PcSignalArray=[PcSignalArray PcSignal];
        end
        SignalExecptFirstToa=SignalArray.*PcSignalArray(1:length(SignalArray));
    case 6%重频滑变 三角形状
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
            JitterPriArray{I}=PulseArray;
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
        SignalArray=[];
        for i=1:length(JitterPriArray)
            SignalArray=[SignalArray JitterPriArray{i}];
        end
        SignalArray=repmat(SignalArray,1,PriNum/(TriangleSlidingNumOneCycle));
        %%%%%%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompletePriTime*PriNum/(TriangleSlidingNumOneCycle);
        SignalNum=ceil(SignalTime/PulseWidth);
        PcSignalArray=[];
        for i=1:SignalNum
            PcSignalArray=[PcSignalArray PcSignal];
        end
        SignalExecptFirstToa=SignalArray.*PcSignalArray(1:length(SignalArray));
    case 7%重频滑变 正弦形状
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
            JitterPriArray{I}=PulseArray;
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
        SignalArray=[];
        for i=1:length(JitterPriArray)
            SignalArray=[SignalArray JitterPriArray{i}];
        end
        SignalArray=repmat(SignalArray,1,PriNum/(SineSlidingNumOneCycle));
        
        %%%%%%%%%%%%%%%%%%%%%%%生成信号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SignalTime=CompletePriTime*PriNum/(SineSlidingNumOneCycle);
        SignalNum=ceil(SignalTime/PulseWidth);
        PcSignalArray=[];
        for i=1:SignalNum
            PcSignalArray=[PcSignalArray PcSignal];
        end
        SignalExecptFirstToa=SignalArray.*PcSignalArray(1:length(SignalArray));
end




