clc;
clear all;
close all;
TotalSignalNum=input('同时发射的信号总数目（1~3）：');
%%  模块1：雷达发射信号
% 模块功能：产生多部雷达信号；
% 初始化参数存储
RadarParams = cell(1, TotalSignalNum);
for i=1:TotalSignalNum
    RadarNum=input('雷达序号（1~3）：');
    SignalNum=input('信号类型序号（1~9）：');
    switch RadarNum
        case 1 %雷达1
            switch SignalNum
                case 1 %单频信号
                    PulseWidth=1e-6;%脉冲宽度1
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=5;%信号幅度
                    CarrierFrequency=160e6;%信号载频
                    PriType=4;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=10e-6;%脉冲重复周期
                    FirstPulseToa=2e-6;
                    OneTimeSlidingMaxRange=7e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=10;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=4;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=3;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncSingleFrequencySignal(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,OneTimeSlidingMaxRange,PulseGroupUnevenPulseNumInGroup,PulseGroupUnevenGroupNum,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生单频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 2 %脉间捷变频信号
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=rand(1,1)*Pri;
                    RapidFrequencyRange=100e6;%捷变范围
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    RapidFrequencyPointNum=60;%捷变点数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncRapidFrequencySignalPulse(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,RapidFrequencyRange,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,SawtoothSlidingNumOneCycle,OneTimeSlidingMaxRange,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,RapidFrequencyPointNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生脉间捷变频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 3 %脉组捷变频信号
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=rand(1,1)*Pri;
                    RapidFrequencyRange=100e6;%捷变范围
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseGroupRapidFrequencyPulseNumInOneGroup=3;%脉组捷变频一个组内的脉冲数目
                    RapidFrequencyPointNum=60;%捷变点数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncRapidFrequencySignalPulseGroup(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,RapidFrequencyRange,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,SawtoothSlidingNumOneCycle,OneTimeSlidingMaxRange,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseGroupRapidFrequencyPulseNumInOneGroup,RapidFrequencyPointNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生脉组捷变频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 4
                    BandWidth=20e6;%信号带宽
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=160e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=6e-6;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    LfmType=1;%调频类型：1：正调频；2：负调频
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncLFMSignal(BandWidth,PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,LfmType,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 5 %双线性调频信号
                    Amplitude=10;%信号幅度
                    SamplingFrequency=1000e6;%采样频率
                    CarrierFrequency=150e6;%信号载频
                    PulseWidth=2e-6;%脉冲宽度
                    BandWidth=60e6;%信号带宽
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncTriangularWaveSignal(Amplitude,SamplingFrequency,CarrierFrequency,PulseWidth,BandWidth,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生双线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 6 %非线性调频信号
                    BandWidth=50e6;%信号带宽
                    PulseWidth=2e-6;%脉冲宽度
                    Amplitude=10;%信号幅度
                    SamplingFrequency=1000e6;%采样频率
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncNLFMSignal(BandWidth,PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生非线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 7 %相位编码信号
                    CarrierFrequency=350e6;%信号载频
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    SubcodeWidth=2e-6;%子码宽度
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    CodeType=3;%相位编码信号编码类型
                    Pri=80e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = 10e-6;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncPCSignal(CarrierFrequency,SamplingFrequency,Amplitude,SubcodeWidth,PriType,CodeType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生相位编码信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 8 %频率分集（同时）信号
                    FrequencyDiversityNum=3;%频率分集数目
                    SamplingFrequency=1000e6;%采样频率
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseWidth=2e-6;%脉冲宽度
                    FrequencyDiversityFrequencyNum=[110.2e6 220.3e6 50.8e6];%分集频率
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncFrequencyDiversitySignal(FrequencyDiversityNum,SamplingFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseWidth,FrequencyDiversityFrequencyNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生频率分集（同时）信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 9 %频率分集（分时）信号
                    FrequencyDiversityNum=3;%频率分集数目
                    SamplingFrequency=1000e6;%采样频率
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseWidth=2e-6;%脉冲宽度
                    FrequencyDiversityTimeInterval=0.6e-6;%分集信号分时间隔
                    FrequencyDiversityFrequencyNum=[110.2e6 220.3e6 150.8e6];%分集频率
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    %记录当前雷达参数
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncFrequencyDiversitySignalTimeSeparate(FrequencyDiversityNum,SamplingFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseWidth,FrequencyDiversityTimeInterval,FrequencyDiversityFrequencyNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生频率分集（分时）信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
            end
        case 2 %雷达2
            switch SignalNum
                case 1 %单频信号
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=130e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa = 2e-6;%第一个脉冲到达时间
                    OneTimeSlidingMaxRange=5e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncSingleFrequencySignal(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,OneTimeSlidingMaxRange,PulseGroupUnevenPulseNumInGroup,PulseGroupUnevenGroupNum,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生单频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 2 %脉间捷变频信号
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=rand(1,1)*Pri;
                    RapidFrequencyRange=50e6;%捷变范围
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    RapidFrequencyPointNum=60;%捷变点数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncRapidFrequencySignalPulse(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,RapidFrequencyRange,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,SawtoothSlidingNumOneCycle,OneTimeSlidingMaxRange,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,RapidFrequencyPointNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生脉间捷变频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 3 %脉组捷变频信号
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=rand(1,1)*Pri;
                    RapidFrequencyRange=50e6;%捷变范围
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseGroupRapidFrequencyPulseNumInOneGroup=3;%脉组捷变频一个组内的脉冲数目
                    RapidFrequencyPointNum=60;%捷变点数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncRapidFrequencySignalPulseGroup(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,RapidFrequencyRange,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,SawtoothSlidingNumOneCycle,OneTimeSlidingMaxRange,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseGroupRapidFrequencyPulseNumInOneGroup,RapidFrequencyPointNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生脉组捷变频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 4
                    BandWidth=20e6;%信号带宽
                    PulseWidth=0.5e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=160e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=25e-6;%脉冲重复周期
                    FirstPulseToa=6e-6;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    LfmType=1;%调频类型：1：正调频；2：负调频
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=4;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=3;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncLFMSignal(BandWidth,PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,LfmType,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 5 %双线性调频信号
                    Amplitude=10;%信号幅度
                    SamplingFrequency=1000e6;%采样频率
                    CarrierFrequency=150e6;%信号载频
                    PulseWidth=2e-6;%脉冲宽度
                    BandWidth=60e6;%信号带宽
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncTriangularWaveSignal(Amplitude,SamplingFrequency,CarrierFrequency,PulseWidth,BandWidth,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生双线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 6 %非线性调频信号
                    BandWidth=50e6;%信号带宽
                    PulseWidth=2e-6;%脉冲宽度
                    Amplitude=10;%信号幅度
                    SamplingFrequency=1000e6;%采样频率
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                     ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncNLFMSignal(BandWidth,PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生非线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 7 %相位编码信号
                    CarrierFrequency=350e6;%信号载频
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    SubcodeWidth=2e-6;%子码宽度
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    CodeType=4;%相位编码信号编码类型
                    Pri=80e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = 10e-6;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncPCSignal(CarrierFrequency,SamplingFrequency,Amplitude,SubcodeWidth,PriType,CodeType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生相位编码信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 8 %频率分集（同时）信号
                    FrequencyDiversityNum=3;%频率分集数目
                    SamplingFrequency=1000e6;%采样频率
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=80e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseWidth=10e-6;%脉冲宽度
                    FrequencyDiversityFrequencyNum=[110.2e6 220.3e6 150.8e6];%分集频率
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncFrequencyDiversitySignal(FrequencyDiversityNum,SamplingFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseWidth,FrequencyDiversityFrequencyNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生频率分集（同时）信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 9 %频率分集（分时）信号
                    FrequencyDiversityNum=3;%频率分集数目
                    SamplingFrequency=1000e6;%采样频率
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=80e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseWidth=10e-6;%脉冲宽度
                    FrequencyDiversityTimeInterval=2e-6;%分集信号分时间隔
                    FrequencyDiversityFrequencyNum=[110.2e6 220.3e6 150.8e6];%分集频率
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncFrequencyDiversitySignalTimeSeparate(FrequencyDiversityNum,SamplingFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseWidth,FrequencyDiversityTimeInterval,FrequencyDiversityFrequencyNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生频率分集（分时）信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
            end
        case 3 %雷达3
            switch SignalNum
                case 1 %单频信号
                    PulseWidth=1e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=7;%信号幅度
                    CarrierFrequency=180e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3e-6;
                    OneTimeSlidingMaxRange=5e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=4;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=3;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncSingleFrequencySignal(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,OneTimeSlidingMaxRange,PulseGroupUnevenPulseNumInGroup,PulseGroupUnevenGroupNum,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生单频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 2 %脉间捷变频信号
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=rand(1,1)*Pri;
                    RapidFrequencyRange=50e6;%捷变范围
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    RapidFrequencyPointNum=60;%捷变点数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncRapidFrequencySignalPulse(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,RapidFrequencyRange,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,SawtoothSlidingNumOneCycle,OneTimeSlidingMaxRange,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,RapidFrequencyPointNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生脉间捷变频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 3 %脉组捷变频信号
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=rand(1,1)*Pri;
                    RapidFrequencyRange=50e6;%捷变范围
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseGroupRapidFrequencyPulseNumInOneGroup=3;%脉组捷变频一个组内的脉冲数目
                    RapidFrequencyPointNum=60;%捷变点数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncRapidFrequencySignalPulseGroup(PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,RapidFrequencyRange,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,SawtoothSlidingNumOneCycle,OneTimeSlidingMaxRange,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseGroupRapidFrequencyPulseNumInOneGroup,RapidFrequencyPointNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生脉组捷变频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 4
                    BandWidth=20e6;%信号带宽
                    PulseWidth=2e-6;%脉冲宽度
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    CarrierFrequency=160e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=6e-6;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    LfmType=1;%调频类型：1：正调频；2：负调频
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncLFMSignal(BandWidth,PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,LfmType,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 5 %双线性调频信号
                    Amplitude=10;%信号幅度
                    SamplingFrequency=1000e6;%采样频率
                    CarrierFrequency=150e6;%信号载频
                    PulseWidth=2e-6;%脉冲宽度
                    BandWidth=60e6;%信号带宽
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncTriangularWaveSignal(Amplitude,SamplingFrequency,CarrierFrequency,PulseWidth,BandWidth,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生双线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 6 %非线性调频信号
                    BandWidth=50e6;%信号带宽
                    PulseWidth=2e-6;%脉冲宽度
                    Amplitude=10;%信号幅度
                    SamplingFrequency=1000e6;%采样频率
                    CarrierFrequency=150e6;%信号载频
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=20e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                     ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncNLFMSignal(BandWidth,PulseWidth,SamplingFrequency,Amplitude,CarrierFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生非线性调频信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 7 %相位编码信号
                    CarrierFrequency=350e6;%信号载频
                    SamplingFrequency=1000e6;%采样频率
                    Amplitude=10;%信号幅度
                    SubcodeWidth=2e-6;%子码宽度
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    CodeType=4;%相位编码信号编码类型
                    Pri=80e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = 10e-6;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncPCSignal(CarrierFrequency,SamplingFrequency,Amplitude,SubcodeWidth,PriType,CodeType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生相位编码信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 8 %频率分集（同时）信号
                    FrequencyDiversityNum=3;%频率分集数目
                    SamplingFrequency=1000e6;%采样频率
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=80e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseWidth=10e-6;%脉冲宽度
                    FrequencyDiversityFrequencyNum=[110.2e6 220.3e6 150.8e6];%分集频率
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncFrequencyDiversitySignal(FrequencyDiversityNum,SamplingFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseWidth,FrequencyDiversityFrequencyNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生频率分集（同时）信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
                case 9 %频率分集（分时）信号
                    FrequencyDiversityNum=3;%频率分集数目
                    SamplingFrequency=1000e6;%采样频率
                    PriType=1;%重频类型：1，重频固定；2，重频参差（脉冲间）；3，重频参差（脉组间）；4：重频抖动；5：重频滑变（锯齿）；6：重频滑变（三角）；7：重频滑变（正弦）
                    Pri=80e-6;%脉冲重复周期
                    FirstPulseToa=3*rand(1,1)*Pri;
                    PulseGroupUnevenGroupNum=3;%重频类型为脉组参差时参差的组数
                    PulseGroupUnevenPulseNumInGroup=4;%重频类型为脉组参差时组内脉冲数目
                    OneTimeSlidingMaxRange=10e-6;%重频类型为滑变时的滑变一次的最大滑变范围
                    SawtoothSlidingNumOneCycle=5;%重频类型为滑变时锯齿滑变周期内滑变次数
                    TriangleSlidingNumOneCycle=5;%重频类型为滑变时三角滑变周期内滑变次数
                    SineSlidingNumOneCycle=5;%重频类型为滑变时正弦滑变周期内滑变次数
                    PulseWidth=10e-6;%脉冲宽度
                    FrequencyDiversityTimeInterval=2e-6;%分集信号分时间隔
                    FrequencyDiversityFrequencyNum=[110.2e6 220.3e6 150.8e6];%分集频率
                    PulseUnevenPulseNum=3;%重频类型为脉间参差时参差脉冲数
                    PulseUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉间参差时参差Pri
                    PulseGroupUnevenPri=[25e-6 30e-6 35e-6];%重频类型为脉组参差时参差Pri
                    JitterPercentage=20;%重频类型为抖动时抖动百分比
                    AntennaScanningCycle=2000e-6;%天线扫描周期
                    ScanningType=1;%天线扫描方式：1，圆周扫描；2，圆锥扫描；3，扇形扫描；4，连续照射；
                    AmplitudeStabilityCoefficient=0.9;%幅度稳定系数；
                    AntennaPatternFunctionType=1;%天线方向图函数类型：1，余弦函数；2，高斯函数；3，辛克函数；
                    MaxAngleOfTargetDeviationFromAntennaAxis=pi/3;%目标偏离天线轴最大角；
                    ProportionalConstant=0.9;%比例常数；
                    HalfPowerBeamWidth=pi/4;%半功率波束宽度；
                    ZeroPowerBeamWidth=pi/4;%零功率波束宽度；
                    RadarParams{i}.FirstPulseToa = FirstPulseToa;
                    RadarParams{i}.PulseWidth = PulseWidth;
                    %信号生成
                    [SignalExecptFirstToa,AntennaScanningCycleNum,RoundFirstPulseToa]=FuncFrequencyDiversitySignalTimeSeparate(FrequencyDiversityNum,SamplingFrequency,PriType,Pri,FirstPulseToa,PulseGroupUnevenGroupNum,PulseGroupUnevenPulseNumInGroup,OneTimeSlidingMaxRange,SawtoothSlidingNumOneCycle,TriangleSlidingNumOneCycle,SineSlidingNumOneCycle,PulseWidth,FrequencyDiversityTimeInterval,FrequencyDiversityFrequencyNum,PulseUnevenPulseNum,PulseUnevenPri,PulseGroupUnevenPri,JitterPercentage,AntennaScanningCycle);%产生频率分集（分时）信号
                    [AntennaScanningAmplitude]=FuncAntennaScanning(ScanningType,AmplitudeStabilityCoefficient,AntennaScanningCycle,SamplingFrequency,AntennaPatternFunctionType,MaxAngleOfTargetDeviationFromAntennaAxis,ProportionalConstant,HalfPowerBeamWidth,ZeroPowerBeamWidth);
                    [Signal]=FuncSignalWithAntennaScanningAmplitude(AntennaScanningCycle,SamplingFrequency,SignalExecptFirstToa,AntennaScanningCycleNum,AntennaScanningAmplitude,RoundFirstPulseToa);
            end   
    end
    TotalSignal{i}=Signal;
end
disp(['信号产生模块完成！']);
%% 修改后的接收信号模块 （暂时没加时延）
disp('进入接收信号模块......');

% 参数设置（保持不变）
SNR = 5; 
ReceivingElementNum = 8;  
c = 3e8; 
Wavelength = c / CarrierFrequency; 
ElementInterval = 0.5 * Wavelength; 

% 信号可视化 - 原始雷达信号
figure('Name', '原始雷达信号', 'Position', [100, 100, 1300, 700]);
for i = 1:numel(TotalSignal)
    signal = TotalSignal{i};
    params = RadarParams{i};  % 获取当前雷达参数  
    % 时域图 
    subplot(numel(TotalSignal), 2, (i-1)*2+1);
    plot( real(signal)); 
    title(['雷达', num2str(i), ' 时域信号 (PW=', ...
        num2str(params.PulseWidth*1e6), 'μs, TOA=', ...
        num2str(params.FirstPulseToa*1e6), 'μs)']);
    xlabel('采样点'); ylabel('幅度');
    
    % 频域图（保持不变）
    subplot(numel(TotalSignal), 2, (i-1)*2+2);
    [Pxx, F] = periodogram(signal, [], 4096, SamplingFrequency/1e6);
    plot(F, 10*log10(Pxx));
    title(['雷达', num2str(i), ' 频谱']);
    xlabel('频率 (MHz)'); ylabel('功率谱密度 (dB)');
    grid on;
end

% 关键修改：为两部雷达指定独立方向角（示例值）
theta = [25, 40,50,10,20,30,45,55,15,35,60,22,26,54,38,42]; % 雷达1=25°, 雷达2=40°（实际根据场景调整）

% 预分配内存（适配两部雷达）
ReceivedSignal = cell(1, numel(TotalSignal)); % 1x2 cell
V = cell(1, numel(TotalSignal)); % 1x2 cell

% 并行计算设置（保持不变）
if isempty(gcp('nocreate'))
    parpool('local');
end

% 噪声功率计算（保持不变）
noisePower = 10^(-SNR/10);
refPower = mean(cellfun(@(x) mean(abs(x).^2), TotalSignal));

% 处理两部雷达信号
for SignalNum = 1:numel(TotalSignal)
    signal = TotalSignal{SignalNum};
    N = length(signal);
    
    % 生成噪声（两部雷达独立生成）
    complexNoise = sqrt(noisePower * refPower / 2) * ...
                   (randn(ReceivingElementNum, N) + 1j * randn(ReceivingElementNum, N));
    V{SignalNum} = complexNoise;
    
    % 计算阵列响应（使用各自的方向角）
    arrayPositions = (0:ReceivingElementNum-1) * ElementInterval;
    steeringVector = exp(-1j * 2 * pi * arrayPositions.' * sind(theta(SignalNum)) / Wavelength);

    % 接收信号合成（两部雷达独立）
    ReceivedSignal{SignalNum} = steeringVector * signal + V{SignalNum};
end

% 显示信息（修改为两部雷达）
disp(['接收信号模块完成！共处理 ', num2str(numel(TotalSignal)), ' 部雷达']);
disp(['雷达方向角: ', num2str(theta), ' 度']);

% 接收信号可视化（时域+频域）
figure('Name', '接收阵列信号', 'Position', [100, 100, 1400, 700]);
for radarIdx = 1:numel(ReceivedSignal)
    % 选择前3个阵元显示
    for elem = 1:min(3, ReceivingElementNum)
        % 提取当前阵元信号
        sig = ReceivedSignal{radarIdx}(elem, :);
        
        % 时域信号子图
        subplot(numel(ReceivedSignal)*2, 3, (radarIdx-1)*6 + elem);
        
        % 提取包含脉冲的区段（增加前后保护间隔）
        startIdx = max(1, (FirstPulseToa * SamplingFrequency) - 100);
        endIdx = min(length(sig), (FirstPulseToa * SamplingFrequency) + PulseWidth * SamplingFrequency + 400);
        timeSegment = real(sig(startIdx:endIdx));
        
        % 时域绘图
        plot(timeSegment);
        title(['雷达', num2str(radarIdx), ' 阵元', num2str(elem), ' 时域信号']);
        xlabel('采样点'); ylabel('幅度');
        grid on;
        
        % 频域信号子图
        subplot(numel(ReceivedSignal)*2, 3, (radarIdx-1)*6 + elem + 3);
        
        % 计算频谱
        N = length(sig);
        f = (-SamplingFrequency/2:SamplingFrequency/N:SamplingFrequency/2 - SamplingFrequency/N);
        spectrum = fftshift(abs(fft(sig, N)));
        
        % 频域绘图
        plot(f/1e6, 20*log10(spectrum/max(spectrum))); % 转换为MHz和dB单位
        title(['雷达', num2str(radarIdx), ' 阵元', num2str(elem), ' 频谱']);
        xlabel('频率 (MHz)'); ylabel('幅度 (dB)');
        grid on;
        xlim([-SamplingFrequency/2/1e6, SamplingFrequency/2/1e6]); % 显示全带宽
        
        % 添加中心频率参考线
        hold on;
        yRange = ylim;
        plot([0, 0], yRange, 'r--', 'LineWidth', 0.8);
        hold off;
    end
end

% 调整子图间距
set(gcf, 'Color', 'w');
h = findobj(gcf, 'Type', 'axes');
set(h, 'FontSize', 9);

% 阵列方向图可视化（优化版）
figure('Name', '阵列方向图', 'Position', [100, 100, 800, 600]);
angles = -90:0.5:90;
arrayResponse = zeros(TotalSignalNum, numel(angles)); % 预分配内存

% 计算每个波束指向的方向图
for radarIdx = 1:TotalSignalNum
    % 计算导向矢量矩阵
    steeringMatrix = exp(-1j * 2 * pi * arrayPositions.' * sind(angles) / Wavelength);
    
    % 计算当前波束指向的权向量
    weightVector = exp(-1j * 2 * pi * arrayPositions.' * sind(theta(radarIdx)) / Wavelength);
    
    % 计算阵列响应（权向量与导向矢量内积）
    response = weightVector' * steeringMatrix;
    pattern = abs(response);
    
    % 归一化并存储结果
    arrayResponse(radarIdx, :) = pattern / max(pattern);
    
    % 绘制方向图（极坐标）
    polarplot(deg2rad(angles), arrayResponse(radarIdx, :), 'LineWidth', 1.5);
    hold on;
end

% 图形美化
title('阵列方向图');
legend(arrayfun(@(i) sprintf('雷达%d (%.1f°)', i, theta(i)), 1:TotalSignalNum, 'UniformOutput', false), ...
       'Location', 'BestOutside');
set(gcf, 'Color', 'w');
grid on;
hold off;

%% 优化后的数字信道化模块
disp('进入数字信道化信号模块......');

% 获取雷达数量和阵元数量
radarNum = numel(ReceivedSignal);  % 雷达数量
if radarNum > 0
    elementNum = size(ReceivedSignal{1}, 1);  % 阵元数量
else
    elementNum = 0;
end

% 获取最小信号长度
minLength = min(cellfun(@(x) size(x,2), ReceivedSignal));

% 初始化参数
ChannelNum = 16; 
SignalAfterDigitalChannelization = cell(radarNum, elementNum); 
SignalAfterDigitalChannelizationTotal = cell(radarNum, elementNum); 
ChannelNumAfterDigitalChannelization = zeros(radarNum, elementNum); 

% 对每部雷达的每个阵元处理
for radarIdx = 1:radarNum
    for elementIdx = 1:elementNum
        % 提取当前阵元信号
        signal = ReceivedSignal{radarIdx}(elementIdx, 1:minLength);
        
        % 信道化处理
        [SignalAfterDigitalChannelization{radarIdx, elementIdx}, ...
         ChannelNumAfterDigitalChannelization(radarIdx, elementIdx), ...
         SignalAfterDigitalChannelizationTotal{radarIdx, elementIdx}] = ...
            FuncDigitalChannelization(ChannelNum, signal, SamplingFrequency);
    end
end

% 更新采样率
newSamplingFrequency = SamplingFrequency / ChannelNum;
disp(['信道化完成，更新采样率为：', num2str(newSamplingFrequency/1e6), 'MHz']);

%% 数字信道化结果综合可视化
[~, ~,~] = FuncDigitalChannelization(ChannelNum, signal, SamplingFrequency,'Plot', 'Valid'); % 有效信道
[~, ~,~] = FuncDigitalChannelization(ChannelNum, signal, SamplingFrequency,'Plot', 'All'); % 所有信道

% 创建专业级可视化图窗 - 简化版
figure('Name', '数字信道化核心分析', 'Position', [100, 100, 1200, 750], 'Color', 'w');

% 选择第一部雷达的第一个阵元作为示例
radarIdx = 1;
elementIdx = 1;
sig = ReceivedSignal{radarIdx}(elementIdx, 1:minLength);
chanTotal = SignalAfterDigitalChannelizationTotal{radarIdx, elementIdx};
validChans = SignalAfterDigitalChannelization{radarIdx, elementIdx};
fs = SamplingFrequency;
D = ChannelNum;
channel_width = fs / D; % 信道带宽

% 1. 原始信号分析（时域） - 优化脉冲展示
subplot(2, 2, 1);
hold on;

% 计算合理的展示范围（脉冲前后各扩展1/4脉宽）
prePulseSamples = round(0.25 * PulseWidth * fs);
pulseStartIdx = max(1, round(FirstPulseToa * fs) - prePulseSamples);
pulseEndIdx = min(length(sig), round((FirstPulseToa + PulseWidth) * fs) + prePulseSamples);

% % 标记脉冲位置
pulseStartTime = FirstPulseToa * 1e6;
pulseEndTime = pulseStartTime + PulseWidth * 1e6;
yRange = ylim;
timeAxis = (pulseStartIdx:pulseEndIdx)/fs * 1e6; % 微秒

% % 绘制噪底区域
% noiseColor = [0.92, 0.92, 0.95];
% rectangle('Position', [timeAxis(1), yRange(1), pulseStartTime - timeAxis(1), diff(yRange)], ...
%           'FaceColor', noiseColor, 'EdgeColor', 'none');
% rectangle('Position', [pulseEndTime, yRange(1), timeAxis(end) - pulseEndTime, diff(yRange)], ...
%           'FaceColor', noiseColor, 'EdgeColor', 'none');
% 
% % 标记脉冲区段
% pulseColor = [1, 0.95, 0.9];
% rectangle('Position', [pulseStartTime, yRange(1), pulseEndTime - pulseStartTime, diff(yRange)], ...
%           'EdgeColor', 'r', 'LineWidth', 2, 'FaceColor', pulseColor);

% 绘制时域信号（含脉冲前后噪底）
signalSegment = real(sig(pulseStartIdx:pulseEndIdx));
plot(timeAxis, signalSegment, 'LineWidth', 1.5, 'Color', [0.1, 0.4, 0.7]);



% 添加标签
text(pulseStartTime + (pulseEndTime - pulseStartTime)/2, yRange(1) + 0.05*diff(yRange), ...
     '脉冲区段', 'Color', 'r', 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'FontSize', 10);
text(timeAxis(1) + 0.05*diff(timeAxis([1,end])), yRange(1) + 0.92*diff(yRange), ...
     '噪底', 'Color', 'r', 'FontAngle', 'italic');
text(timeAxis(end) - 0.05*diff(timeAxis([1,end])), yRange(1) + 0.92*diff(yRange), ...
     '噪底', 'Color', 'r', 'FontAngle', 'italic', 'HorizontalAlignment', 'right');

% 添加统计信息
pulseSegment = sig(round(FirstPulseToa*fs):round((FirstPulseToa+PulseWidth)*fs));
noiseSegment = [sig(1:round(FirstPulseToa*fs-100)), sig(round((FirstPulseToa+PulseWidth)*fs+100):end)];
pulsePower = 10*log10(mean(abs(pulseSegment).^2));
noisePower = 10*log10(mean(abs(noiseSegment).^2));
snr = pulsePower - noisePower;

text(pulseStartTime + (pulseEndTime - pulseStartTime)/2, yRange(1) + 0.92*diff(yRange), ...
     sprintf('SNR: %.1f dB', snr), 'Color', 'g', 'HorizontalAlignment', 'center', 'FontSize', 10);

% 添加时间标记
plot([pulseStartTime, pulseStartTime], ylim, 'r--', 'LineWidth', 1);
plot([pulseEndTime, pulseEndTime], ylim, 'r--', 'LineWidth', 1);

title('原始信号时域波形（脉冲区段展示）');
xlabel('时间 (\mus)');
ylabel('幅度');
grid on;
box on;
hold off;

% 2. 原始信号频谱
subplot(2, 2, 2);
N = min(8192, length(sig));  % 限制FFT点数
freqAxis = linspace(-fs/2, fs/2, N)/1e6;
spectrum = fftshift(abs(fft(sig, N)));
plot(freqAxis, 20*log10(spectrum/max(spectrum + eps)), 'LineWidth', 1, 'Color', 'b');

title('原始信号频谱');
xlabel('频率 (MHz)');
ylabel('幅度 (dB)');
grid on;
xlim([-fs/2e6, fs/2e6]);

% 3. 有效信道频谱对比 - 精确频率计算
subplot(2, 2, 3);
hold on;

% 计算精确的信道中心频率
centerFreqs = ((0:D-1)) * channel_width ; % 精确中心频率公式

% 检测有效信道
channel_power = zeros(1, D);
for k = 1:D
    channel_power(k) = mean(abs(chanTotal(k, :)).^2);
end
noise_floor = min(channel_power);
threshold = 10^(10/10) * noise_floor;  % 10dB阈值
validChannelIndices = find(channel_power > threshold);
numValidChans = length(validChannelIndices);

% 设置统一的频率范围
ylim([-120, 10]); % 合理的功率范围

% 绘制背景参考线
plot([-fs/2e6, fs/2e6], [-100, -100], 'k:', 'LineWidth', 0.5, 'HandleVisibility', 'off'); % -100dB参考线

% 计算并绘制每个有效信道的频谱
colors = lines(numValidChans); % 为有效信道分配颜色

for idx = 1:numValidChans
    k = validChannelIndices(idx);
    chanSig = validChans(idx, :);
    
    % 计算实际中心频率 (MHz)
    centerFreq_MHz = centerFreqs(k)/1e6;
    
    % 计算该信道的频谱（使用实际采样率）
    [Pxx, F_base] = pwelch(chanSig, hanning(1024), 512, 4096, channel_width);
    
    % 将基带频谱平移到实际中心频率
    F_actual = F_base + centerFreqs(k); % Hz单位
    F_actual_MHz = F_actual / 1e6;     % 转换为MHz
    
    % 找到频谱峰值位置
    [maxPxx, maxIdx] = max(Pxx);
    peakFreq_MHz = F_actual_MHz(maxIdx);
    
    % 绘制平移后的频谱
    plot(F_actual_MHz, 10*log10(Pxx), 'LineWidth', 2, ...
         'Color', colors(idx, :), ...
         'DisplayName', sprintf('Ch%d:峰值%.1f MHz', k, peakFreq_MHz));
    
    % 标记理论中心频率
    plot([centerFreq_MHz, centerFreq_MHz], ylim, '--', ...
         'Color', colors(idx, :), 'LineWidth', 1,'DisplayName', sprintf('未搬移前的基带中心频率'));
    
    % 标记实际峰值频率
    plot(peakFreq_MHz, 10*log10(maxPxx), 'o', ...
         'MarkerSize', 5, 'MarkerFaceColor', colors(idx, :), ...
         'MarkerEdgeColor', 'k','DisplayName', sprintf('实际峰值频率'));
    
    % 添加频率偏差标注
    freqError = abs(peakFreq_MHz - centerFreq_MHz);
    text(peakFreq_MHz, 10*log10(maxPxx)-5, sprintf('Δf=%.2fMHz', freqError), ...
         'HorizontalAlignment', 'center', 'Color', 'r', 'FontSize', 9);
end

% 添加原始信号频率标记（如果已知）
if exist('SignalFreq', 'var')
    signalFreq_MHz = SignalFreq/1e6;
    plot([signalFreq_MHz, signalFreq_MHz], ylim, 'm--', 'LineWidth', 2);
    text(signalFreq_MHz, max(ylim)-5, '原始信号频率', ...
         'Color', 'm', 'HorizontalAlignment', 'center', 'FontWeight', 'bold');
end

title('有效信道频谱');
xlabel('频率 (MHz)');
ylabel('功率 (dB)');
legend('show', 'Location', 'best');
grid on;
box on;
hold off;

% 4. 信道功率分布与时域波形
subplot(2, 2, 4);
hold on;

% 创建左右双纵轴
yyaxis left;

% 绘制信道功率分布
bar(1:D, 10*log10(channel_power + eps), 'FaceColor', [0.8, 0.8, 0.9], 'BarWidth', 0.6);

% 标记有效信道
for idx = 1:numValidChans
    k = validChannelIndices(idx);
    bar(k, 10*log10(channel_power(k) + eps), 'FaceColor', colors(idx, :), 'BarWidth', 0.6);
end

% 添加阈值线
threshold_dB = 10*log10(threshold + eps);
plot([0, D+1], [threshold_dB, threshold_dB], ...
     'r--', 'LineWidth', 2);
text(D/2, threshold_dB + 2, sprintf('检测阈值 (%.1f dB)', threshold_dB), ...
     'Color', 'r', 'HorizontalAlignment', 'center', 'FontSize', 10);

ylabel('功率 (dB)');
ylim([threshold_dB-20, max(10*log10(channel_power + eps))+5]);

% % 添加时域波形（右侧轴）
% yyaxis right;
% if numValidChans > 0
%     % 绘制第一个有效信道的时域波形
%     k = validChannelIndices(1);
%     timeAxis = (0:size(validChans, 2)-1) / (fs/D) * 1e6;
%     plotLength = min(200, size(validChans, 2));
%     sigSegment = real(validChans(1, 1:plotLength));
%     sigSegment = sigSegment / max(abs(sigSegment));
%     
%     plot(timeAxis(1:plotLength), sigSegment, 'LineWidth', 1.5, 'Color', [0.9, 0.3, 0.1]);
%     ylabel('幅度（归一化）');
%     ylim([-1.2, 1.2]);
%     
%     % 添加标题
%     title(sprintf('信道%d时域波形 (%.1fMHz)', k, centerFreqs(k)/1e6));
% else
%     ylabel('幅度');
%     title('无有效信道');
% end

% 设置公共属性
xlabel('信道号');
title('信道功率分布与示例时域波形');
grid on;
xlim([0.5, D+0.5]);
set(gca, 'XTick', 1:D);
box on;
hold off;

% 添加全局标题和统计信息
sgtitle(sprintf('数字信道化核心分析 (雷达%d - 阵元%d)', radarIdx, elementIdx), ...
        'FontSize', 16, 'FontWeight', 'bold');

annotation('textbox', [0.05, 0.01, 0.9, 0.04], 'String', ...
           sprintf('原始采样率: %.1f MHz | 信道数: %d | 有效信道数: %d | 信道带宽: %.1f MHz', ...
                   fs/1e6, D, numValidChans, channel_width/1e6), ...
           'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 11, ...
           'BackgroundColor', [0.94, 0.97, 1]);
%% 信号分选模块
disp('进入信号分选模块......');

% 获取维度信息
numRadars = size(SignalAfterDigitalChannelization, 1); % 雷达数
numChannels = size(SignalAfterDigitalChannelization{1,1}, 1); % 有效信道数
signalLength = size(SignalAfterDigitalChannelization{1,1}, 2); % 信号长度

% 预分配PDW结构（按雷达和子信道存储）
PDW = cell(numRadars, numChannels); 

% 处理每部雷达的每个子信道
for radarIdx = 1:numRadars
    for channelIdx = 1:numChannels
        % 提取当前子信道的多阵元信号（8个阵元）
        multiChannelSignal = zeros(ReceivingElementNum, signalLength);
        
        for elementIdx = 1:ReceivingElementNum
            data = SignalAfterDigitalChannelization{radarIdx, elementIdx};
            
            % 添加边界检查
            if channelIdx <= size(data, 1)
                multiChannelSignal(elementIdx, :) = data(channelIdx, :);
            else
                multiChannelSignal(elementIdx, :) = zeros(1, signalLength);
            end
        end
        
        % 估计PDW参数
        [freq, pri, amp, pw, toa] = ...
            FuncPDWEstimation(multiChannelSignal, newSamplingFrequency);        % 使用数字信道化后的采样率（抽取降采样）
        
        % 存储到结构体
        PDW{radarIdx, channelIdx} = struct(...
            'Frequency', freq, ...
            'PRI', pri, ...
            'Amplitude', amp, ...
            'PulseWidth', pw, ...
            'TOA', toa, ...
            'DOA', []); % DOA待后续统一估计
    end
end

% DOA估计（每部雷达独立进行）
for radarIdx = 1:numRadars
    % 收集当前雷达所有脉冲 - 按正确格式组织
    allPulses = [];
    pulseCount = 0;
    
    % 首先确定有效的脉冲位置（TOA）
    validPulsePositions = [];
    for channelIdx = 1:numChannels
        if ~isempty(PDW{radarIdx, channelIdx}) && ~isempty(PDW{radarIdx, channelIdx}.TOA)
            pulsePos = round(PDW{radarIdx, channelIdx}.TOA * newSamplingFrequency);
            validPos = pulsePos((pulsePos > 0) & (pulsePos <= signalLength));
            validPulsePositions = union(validPulsePositions, validPos);
        end
    end
    
    % 如果没有有效脉冲，跳过
    if isempty(validPulsePositions)
        continue;
    end
    
    % 初始化数据矩阵：阵元数 × 脉冲数
    allPulses = zeros(ReceivingElementNum, numel(validPulsePositions));
    
    % 对每个阵元收集数据
    for elementIdx = 1:ReceivingElementNum
        elementData = [];
        
        % 收集当前阵元在所有信道的数据
        for channelIdx = 1:numChannels
            if ~isempty(PDW{radarIdx, channelIdx}) && ~isempty(PDW{radarIdx, channelIdx}.TOA)
                data = SignalAfterDigitalChannelization{radarIdx, elementIdx};
                if channelIdx <= size(data, 1)
                    % 提取当前信道的数据
                    channelData = data(channelIdx, :);
                    
                    % 提取有效位置的脉冲数据
                    pulseData = channelData(validPulsePositions);
                    elementData = [elementData, pulseData];
                end
            end
        end
        
        % 将当前阵元的数据放入矩阵
        if numel(elementData) >= numel(validPulsePositions)
            allPulses(elementIdx, :) = elementData(1:numel(validPulsePositions));
        else
            % 数据不足时补零
            allPulses(elementIdx, :) = zeros(1, numel(validPulsePositions));
        end
    end
    
    % 统一进行DOA估计（如果有脉冲数据）
    if ~isempty(allPulses) && size(allPulses, 2) > 0
        doa = FuncDOAEstimation(allPulses, newSamplingFrequency, ReceivingElementNum);
        
        % 将DOA赋给当前雷达的所有子信道
        for channelIdx = 1:numChannels
            if ~isempty(PDW{radarIdx, channelIdx})
                PDW{radarIdx, channelIdx}.DOA = doa;
            end
        end
    end
end

disp('信号分选完成！');
% PDW参数可视化
figure('Name', '脉冲参数分布', 'Position', [100, 100, 1400, 700]);

% 收集所有PDW参数
allFreq = []; allPW = []; allPRI = []; allDOA = [];
for radarIdx = 1:numRadars
    for channelIdx = 1:numChannels
        pdw = PDW{radarIdx, channelIdx};
        if ~isempty(pdw) && ~isempty(pdw.Frequency)
            allFreq = [allFreq, pdw.Frequency/1e6]; % MHz
            allPW = [allPW, pdw.PulseWidth*1e6];    % μs
            allPRI = [allPRI, pdw.PRI*1e6];          % μs
            allDOA = [allDOA, pdw.DOA];
        end
    end
end

% 频率分布
subplot(2,2,1);
histogram(allFreq, 20, 'FaceColor', [0.2, 0.6, 0.8]);
title('脉冲频率分布');
xlabel('频率 (MHz)'); ylabel('脉冲数量');
grid on;

% 脉宽分布
subplot(2,2,2);
histogram(allPW, 20, 'FaceColor', [0.8, 0.4, 0.2]);
title('脉冲宽度分布');
xlabel('脉宽 (μs)'); ylabel('脉冲数量');
grid on;

% PRI分布
subplot(2,2,3);
priIntervals = diff(toa)*1e6; % 转换为微秒
histogram(priIntervals, 20, 'FaceColor', [0.4, 0.8, 0.4]);
title('PRI分布');
xlabel('PRI (μs)'); ylabel('脉冲数量');
grid on;

% DOA分布
subplot(2,2,4);
if ~isempty(allDOA)
    % 保存当前坐标轴位置
    originalPos = get(gca, 'Position');
    
    % 删除当前坐标轴
    delete(gca);
    
    % 创建新极坐标轴在相同位置
    ax = polaraxes('Position', originalPos);
    
    % 绘制DOA
    hold(ax, 'on');
    theta = deg2rad(allDOA);
    for i = 1:length(allDOA)
        polarplot(ax, [0, theta(i)], [0, 1], 'r-', 'LineWidth', 2);
        text(1.1*cos(theta(i)), 1.1*sin(theta(i)), ...
            [num2str(allDOA(i)) '°'], ...
            'HorizontalAlignment', 'center', ...
            'FontSize', 10);
    end
    ax.RLim = [0, 1.3];
    ax.RTick = [];
    title(ax, 'DOA估计结果');
    hold(ax, 'off');
else
    text(0.5, 0.5, '无DOA数据', 'HorizontalAlignment', 'center');
end


% 脉冲序列可视化
figure('Name', '脉冲序列', 'Position', [100, 100, 1200, 700]);
hold on;
colors = lines(numRadars);

for radarIdx = 1:numRadars
    toaAll = []; priAll = [];
    for channelIdx = 1:numChannels
        pdw = PDW{radarIdx, channelIdx};
        if ~isempty(pdw) && ~isempty(pdw.TOA)
            toaAll = [toaAll, pdw.TOA];
            priAll = [priAll, pdw.PRI];
        end
    end
   
    if ~isempty(toaAll)
        % 绘制PRI序列
        plot(toaAll(1:end-1)*1e3, priIntervals, 'o-', ...
            'Color', colors(radarIdx,:), 'LineWidth', 1.5, ...
            'DisplayName', sprintf('雷达%d', radarIdx));
    end
end

title('脉冲到达时间序列');
xlabel('到达时间 (ms)'); ylabel('PRI (μs)');
legend('show');
grid on;
set(gca, 'FontSize', 10);

%% 聚类结果可视化（添加）
disp('显示聚类结果...');
figure('Name', '脉冲参数聚类', 'Position', [100, 100, 1200, 700]);

% 确保参数向量长度一致
minLength_JL = min([length(allFreq), length(priIntervals), length(allPW)]);
allFreq = allFreq(1:minLength_JL);
allPRI = priIntervals(1:minLength_JL);
allPW = allPW(1:minLength_JL);

% 准备聚类数据 (频率, PRI, 脉宽)
X = [allFreq', allPRI', allPW'];

% 标准化数据
X_norm = zscore(X);

% 聚类分析
[idx, centers] = kmeans(X_norm, 3, 'Replicates', 5);

% 3D散点图
subplot(1,2,1);
scatter3(X(:,1), X(:,2), X(:,3), 40, idx, 'filled');
title('脉冲参数聚类 (3D)');
xlabel('频率 (MHz)'); 
ylabel('PRI (μs)'); 
zlabel('脉宽 (μs)');
grid on; 
rotate3d on;
colormap(jet);

% 2D投影
subplot(1,2,2);
gscatter(X(:,1), X(:,2), idx, [], 'o', 10);
title('频率-PRI聚类');
xlabel('频率 (MHz)'); 
ylabel('PRI (μs)');
grid on;
legend('Cluster 1', 'Cluster 2', 'Cluster 3');

% 添加聚类中心标记
hold on;
plot(centers(:,1), centers(:,2), 'kx', 'MarkerSize', 15, 'LineWidth', 2);
hold off;
%% 添加处理结果总结表
fprintf('\n================ 处理结果总结 ================\n');
fprintf('雷达数量: %d\n', numRadars);
fprintf('检测脉冲总数: %d\n', numel(allFreq));
fprintf('频率范围: %.1f - %.1f MHz\n', min(allFreq), max(allFreq));
fprintf('脉宽范围: %.1f - %.1f μs\n', min(allPW), max(allPW));
fprintf('PRI范围: %.1f - %.1f μs\n', min(allPRI), max(allPRI));
fprintf('DOA范围: %.1f - %.1f 度\n', min(allDOA), max(allDOA));
fprintf('===========================================\n');

%% %%%%%%%%%%%%%%%%%%%%%% 侦察引导干扰模块 %%%%%%%%%%%%%%%%%%%%%%%%%%
disp('=== 侦察引导干扰决策模块 ===');

% 干扰样式定义
JAMMING_TYPES = struct(...
    'NARROW_TARGETED', 1, ...
    'NARROW_SWEEP', 2, ...
    'WIDE_BLOCK', 3, ...
    'COMB_SPECTRUM', 4, ...
    'SMART_NOISE', 5, ...
    'RANGE_PULL', 6, ...
    'VELOCITY_PULL', 7, ...
    'JOINT_PULL', 8, ...
    'DENSE_TARGETS', 9, ...
    'INTERMITTENT_SAMPLING', 10);

% 干扰样式名称映射
JammingTypeNames = {
    '窄带瞄频干扰', '窄带扫频干扰', '宽带阻塞干扰', ...
    '梳状谱干扰', '灵巧噪声干扰', '距离拖引干扰', ...
    '速度拖引干扰', '距离速度联合拖引干扰', ...
    '密集假目标复制干扰', '间歇采样转发干扰'};

% 雷达工作模式定义
MODES = struct(...
    'SEARCH', 1, ...
    'TRACK', 2, ...
    'ATTACK', 3);

% 设置门限值
P0 = 0;        % 欺骗干扰最大可干扰的功率门限（dB）
Pn1 = -70;       % 距离判断功率门限（dB），大于则为近距离
G_range = [-45, 45];   % 有效方位角范围
% theta_range = [0, 60]; % 有效俯仰角范围
gamma1 = 500e-6; % PRI门限1（搜索模式上限）
gamma2 = 50e-6;  % PRI门限2（跟踪模式上限）

% 第一步：计算每个雷达的功率（相对值，dB）
for i = 1:length(PDW)
    % 从EstimatedParams中获取幅度
    amp = PDW{i}.Amplitude;
    % 转换为dB（相对值，参考值为1）
    PDW{i}.Power = 20*log10(amp);
end

% 第二步：威胁评估
validRadarIndices = []; % 记录有效干扰区域内的雷达索引
threatLevels = zeros(1, length(PDW)); % 威胁等级

for i = 1:length(PDW)
    param = PDW{i};
    % 检查是否在有效干扰区域内
    if param.Power < P0 & ...
       param.DOA(1) >= G_range(1) & param.DOA(1) <= G_range(2) %& ...
%        param.DOA(2) >= theta_range(1) & param.DOA(2) <= theta_range(2)
        validRadarIndices = [validRadarIndices, i];
        
        % 判断工作模式
        if param.PRI <= gamma2
            mode = MODES.ATTACK; % 打击模式
        elseif param.PRI <= gamma1
            mode = MODES.TRACK;  % 跟踪模式
        else
            mode = MODES.SEARCH; % 搜索模式
        end
        threatLevels(i) = mode;
    else
        threatLevels(i) = 0; % 不在有效区域，威胁为0
    end
end

% 在同一模式内根据功率调整威胁等级
for mode = 1:3
    indices = validRadarIndices(threatLevels(validRadarIndices) == mode);
    if isempty(indices)
        continue;
    end
    powers = [PDW{indices}.Power];
    [~, idx_sorted] = sort(powers, 'descend');
    
    % 排序后，排名第一的加0.99，第二加0.98，以此类推
    for k = 1:length(indices)
        rank_val = 1 - (k-1)*0.01; 
        radarIndex = indices(idx_sorted(k));  % 获取正确的雷达索引
        threatLevels(radarIndex) = mode + rank_val;
    end
end

% 第三步：按威胁等级排序，选择前3个
[~, sortedIndices] = sort(threatLevels, 'descend');
selectedRadarIndices = [];
for i = 1:length(sortedIndices)
    if threatLevels(sortedIndices(i)) > 0
        selectedRadarIndices = [selectedRadarIndices, sortedIndices(i)];
        if length(selectedRadarIndices) >= 3
            break;
        end
    end
end

% 第四步：为选中的雷达选择干扰样式并计算参数
jammingDecisions = cell(1, length(PDW)); 

for idx = selectedRadarIndices
    param = PDW{idx};
    mode = floor(threatLevels(idx)); % 取整数部分，即工作模式
    
    % 判断距离（通过功率）
    isCloseRange = param.Power > Pn1;
    
    % 获取载频模式（从原始雷达参数获取）
    freqType = RadarParams{idx}.FreqType; % 0:常规, 1:捷变
    
    % 选择干扰样式
    if mode == MODES.SEARCH % 搜索模式
        if freqType == 0 % 常规载频
            if isCloseRange
                jamType = JAMMING_TYPES.SMART_NOISE;
            else
                jamType = JAMMING_TYPES.NARROW_TARGETED;
            end
        else % 捷变频
            if isCloseRange
                jamType = JAMMING_TYPES.SMART_NOISE;
            else
                jamType = JAMMING_TYPES.COMB_SPECTRUM;
            end
        end
    elseif mode == MODES.TRACK % 跟踪模式
        jamType = JAMMING_TYPES.JOINT_PULL;
    else % 打击模式
        if isCloseRange
            jamType = JAMMING_TYPES.DENSE_TARGETS;
        else
            jamType = JAMMING_TYPES.COMB_SPECTRUM;
        end
    end
    
    % 计算干扰参数
    jamParams = calculateJammingParams(jamType, param);
    
    % 存储决策
    jammingDecisions{idx} = struct(...
        'JammingType', jamType, ...
        'JammingParams', jamParams);
end

% 第五步：显示干扰决策结果
fprintf('\n===== 精确引导干扰决策结果 =====\n');
for idx = selectedRadarIndices
    decision = jammingDecisions{idx};
    param = PDW{idx};
    
    % 获取工作模式名称
    modeValue = floor(threatLevels(idx));
    switch modeValue
        case MODES.SEARCH
            modeName = '搜索模式';
        case MODES.TRACK
            modeName = '跟踪模式';
        case MODES.ATTACK
            modeName = '打击模式';
        otherwise
            modeName = '未知模式';
    end
    
    % 获取载频模式名称
    freqTypeName = '常规载频';
    if RadarParams{idx}.FreqType == 1
        freqTypeName = '捷变频';
    end
    
    fprintf('雷达%d:\n', idx);
    fprintf('  工作模式: %s\n', modeName);
    fprintf('  载频模式: %s\n', freqTypeName);
    fprintf('  威胁等级: %.2f\n', threatLevels(idx));
    fprintf('  干扰样式: %s\n', JammingTypeNames{decision.JammingType});
    
    % 显示干扰参数
    jamParams = decision.JammingParams;
    fprintf('  干扰参数:\n');
    paramNames = fieldnames(jamParams);
    for j = 1:length(paramNames)
        name = paramNames{j};
        value = jamParams.(name);
        
        % 根据参数类型格式化输出
        if contains(name, 'Freq') || contains(name, 'Bandwidth')
            fprintf('    %s: %.2f MHz\n', name, value/1e6);
        elseif contains(name, 'Power')
            fprintf('    %s: %.2f dB\n', name, value);
        elseif contains(name, 'Delta') || contains(name, 'Interval')
            fprintf('    %s: %.2f m\n', name, value);
        elseif contains(name, 'DeltaT')
            fprintf('    %s: %.2f μs\n', name, value*1e6);
        else
            fprintf('    %s: %d\n', name, value);
        end
    end
    fprintf('--------------------------------------\n');
end

%% 快速引导方法
disp('>> 执行快速引导方法 <<');
fastJammingDecisions = cell(1, length(PDW)); 

for i = 1:length(PDW)
    param = PDW{i};
    
    % 判断是否在有效干扰区域
    inRange = (param.Power < P0) & ...
             (param.DOA(1) >= G_range(1) & param.DOA(1) <= G_range(2));
    
    if inRange
        % 简单威胁评估
        if param.PRI <= 50e-6
            threatLevel = 300; % 打击模式
        elseif param.PRI <= 500e-6
            threatLevel = 200; % 跟踪模式
        else
            threatLevel = 100; % 搜索模式
        end
        
        % 功率影响
        threatLevel = threatLevel + (param.Power - P0);
        
        % 选择干扰样式
        if threatLevel >= 250 % 高威胁
            jamType = JAMMING_TYPES.INTERMITTENT_SAMPLING;
        elseif threatLevel >= 150 % 中威胁
            jamType = JAMMING_TYPES.SMART_NOISE;
        else % 低威胁
            if RadarParams{i}.FreqType == 0
                jamType = JAMMING_TYPES.NARROW_TARGETED;
            else
                jamType = JAMMING_TYPES.COMB_SPECTRUM;
            end
        end
        
        fastJammingDecisions{i} = struct(...
            'RadarId', i, ...
            'ThreatLevel', threatLevel, ...
            'JammingType', jamType);
    else
        fastJammingDecisions{i} = struct('RadarId', i, 'ThreatLevel', 0, ...
                                      'JammingType', 0);
    end
end

% 显示快速引导结果
fprintf('\n===== 快速引导干扰决策结果 =====\n');
for i = 1:length(fastJammingDecisions)
    decision = fastJammingDecisions{i};
    if decision.ThreatLevel > 0
        fprintf('雷达%d:\n', decision.RadarId);
        fprintf('  威胁等级: %.2f\n', decision.ThreatLevel);
        fprintf('  干扰样式: %s\n', JammingTypeNames{decision.JammingType});
        fprintf('--------------------------------------\n');
    end
end


%% 可视化：干扰前后对比分析
disp('=== 干扰效果可视化 ===');

% 选择第一部雷达进行详细分析
selectedRadarIdx = selectedRadarIndices(1);
radarSignal = RadarSignals{selectedRadarIdx};
radarParams = RadarParams{selectedRadarIdx};
decision = jammingDecisions{selectedRadarIdx};

% 生成干扰信号
jamSignal = generateJammingSignal(decision, radarSignal, radarParams);

% 干扰信号叠加
jamToSignalRatio = 10; % 干信比(dB)
jamPower = 10^(jamToSignalRatio/10) * mean(abs(radarSignal).^2);
jamSignal = sqrt(jamPower) * jamSignal / rms(jamSignal);
interferedSignal = radarSignal + jamSignal;

% 时域对比
figure('Name', '干扰前后时域对比', 'Position', [100, 100, 1200, 600]);
subplot(3,1,1);
plot(real(radarSignal(1:min(5000,length(radarSignal)))));
title('原始雷达信号 (时域)');
xlabel('采样点'); ylabel('幅度');
grid on;

subplot(3,1,2);
plot(real(jamSignal(1:min(5000,length(jamSignal)))));
title(sprintf('%s干扰信号 (时域)', JammingTypeNames{decision.JammingType}));
xlabel('采样点'); ylabel('幅度');
grid on;

subplot(3,1,3);
plot(real(interferedSignal(1:min(5000,length(interferedSignal)))));
title('干扰后信号 (时域)');
xlabel('采样点'); ylabel('幅度');
grid on;

% 频域对比
figure('Name', '干扰前后频域对比', 'Position', [100, 100, 1200, 600]);
subplot(3,1,1);
[Pxx, F] = pwelch(radarSignal, 1024, 512, 1024, radarParams.SamplingFrequency);
plot(F/1e6, 10*log10(Pxx));
title('原始雷达信号 (频域)');
xlabel('频率 (MHz)'); ylabel('功率谱密度 (dB/Hz)');
grid on;
xlim([0, radarParams.SamplingFrequency/2e6]);

subplot(3,1,2);
[Pxx_jam, F_jam] = pwelch(jamSignal, 1024, 512, 1024, radarParams.SamplingFrequency);
plot(F_jam/1e6, 10*log10(Pxx_jam));
title(sprintf('%s干扰信号 (频域)', JammingTypeNames{decision.JammingType}));
xlabel('频率 (MHz)'); ylabel('功率谱密度 (dB/Hz)');
grid on;
xlim([0, radarParams.SamplingFrequency/2e6]);

subplot(3,1,3);
[Pxx_int, F_int] = pwelch(interferedSignal, 1024, 512, 1024, radarParams.SamplingFrequency);
plot(F_int/1e6, 10*log10(Pxx_int));
title('干扰后信号 (频域)');
xlabel('频率 (MHz)'); ylabel('功率谱密度 (dB/Hz)');
grid on;
xlim([0, radarParams.SamplingFrequency/2e6]);

% 脉冲压缩对比（针对LFM信号）
if radarParams.SignalType == 4 % LFM信号
    figure('Name', '干扰前后脉冲压缩对比', 'Position', [100, 100, 1200, 800]);
    
    % 原始信号脉冲压缩
    [pc_original, t_original] = pulseCompression(radarSignal, radarParams);
    
    % 干扰后信号脉冲压缩
    [pc_interfered, t_interfered] = pulseCompression(interferedSignal, radarParams);
    
    % 绘制结果
    subplot(2,1,1);
    plot(t_original*1e6, abs(pc_original));
    title('原始信号脉冲压缩结果');
    xlabel('时间 (\mus)'); ylabel('幅度');
    grid on;
    
    subplot(2,1,2);
    plot(t_interfered*1e6, abs(pc_interfered));
    title('干扰后信号脉冲压缩结果');
    xlabel('时间 (\mus)'); ylabel('幅度');
    grid on;
    
    % 添加干扰效果说明
    annotation('textbox', [0.3, 0.05, 0.4, 0.05], 'String', ...
        sprintf('干扰样式: %s | 干信比: %d dB', ...
        JammingTypeNames{decision.JammingType}, jamToSignalRatio), ...
        'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 12, ...
        'BackgroundColor', [0.9, 0.95, 1]);
end

% 空间分布对比
figure('Name', '干扰前后空间分布对比', 'Position', [100, 100, 1200, 500]);

% 原始信号空间分布
subplot(1,2,1);
angles = -90:0.5:90;
arrayResponse = zeros(1, length(angles));
steeringVec = exp(-1j*2*pi*(0:ReceivingElementNum-1)'*ElementInterval*sind(angles)/Wavelength);
arrayResponse = abs(sum(steeringVec, 1));
arrayResponse = arrayResponse / max(arrayResponse);
polarplot(deg2rad(angles), arrayResponse, 'LineWidth', 1.5);
title('原始信号空间分布');
rlim([0, 1.2]);

% 干扰后信号空间分布
subplot(1,2,2);
% 假设干扰方向对准雷达方向
jamDOA = PDW{selectedRadarIdx}.DOA(1);
jamSteeringVec = exp(-1j*2*pi*(0:ReceivingElementNum-1)'*ElementInterval*sind(jamDOA)/Wavelength);
jamArrayResponse = abs(sum(steeringVec .* jamSteeringVec, 1));
jamArrayResponse = jamArrayResponse / max(jamArrayResponse);
polarplot(deg2rad(angles), jamArrayResponse, 'LineWidth', 1.5);
title(sprintf('干扰信号空间分布 (方向: %.1f°)', jamDOA));
rlim([0, 1.2]);

% 所有雷达干扰效果综合展示
figure('Name', '干扰效果综合评估', 'Position', [100, 100, 1400, 700]);

% 创建表格数据
radarIDs = [];
modes = {};
freqTypes = {};
jammingTypes = {};
snrReduction = [];
detectionProb = [];

for i = 1:length(selectedRadarIndices)
    idx = selectedRadarIndices(i);
    radarIDs(i) = idx;
    
    % 工作模式
    modeValue = floor(threatLevels(idx));
    switch modeValue
        case MODES.SEARCH, modes{i} = '搜索';
        case MODES.TRACK, modes{i} = '跟踪';
        case MODES.ATTACK, modes{i} = '打击';
    end
    
    % 载频模式
    if RadarParams{idx}.FreqType == 0
        freqTypes{i} = '常规';
    else
        freqTypes{i} = '捷变';
    end
    
    % 干扰样式
    jamType = jammingDecisions{idx}.JammingType;
    jammingTypes{i} = JammingTypeNames{jamType};
    
    % 干扰效果评估（模拟）
    % 信噪比降低量
    switch jamType
        case {1, 4} % 压制式干扰
            snrReduction(i) = 15 + randi(10); % 15-25 dB
        case {5, 9, 10} % 欺骗式干扰
            snrReduction(i) = 5 + randi(10); % 5-15 dB
        otherwise
            snrReduction(i) = 10 + randi(10); % 10-20 dB
    end
    
    % 检测概率
    baseProb = 0.9; % 无干扰检测概率
    detectionProb(i) = max(0.1, baseProb * 10^(-snrReduction(i)/20));
end

% 创建结果表格
resultTable = table(radarIDs', modes', freqTypes', jammingTypes', ...
    snrReduction', detectionProb', ...
    'VariableNames', {'雷达ID', '工作模式', '载频模式', '干扰样式', '信噪比降低(dB)', '检测概率'});

% 显示表格
uitable('Data', resultTable{:,:}, 'ColumnName', resultTable.Properties.VariableNames, ...
    'RowName', [], 'Units', 'Normalized', 'Position', [0.05, 0.1, 0.9, 0.8]);

% 添加标题
annotation('textbox', [0.3, 0.92, 0.4, 0.05], 'String', ...
    '干扰效果综合评估结果', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');

% 干扰效果柱状图
figure('Name', '干扰效果量化分析', 'Position', [100, 100, 1200, 500]);

subplot(1,2,1);
bar(snrReduction, 'FaceColor', [0.2, 0.6, 0.8]);
title('信噪比降低量');
xlabel('雷达编号');
ylabel('降低量 (dB)');
grid on;
set(gca, 'XTickLabel', radarIDs);

subplot(1,2,2);
bar(detectionProb, 'FaceColor', [0.8, 0.4, 0.2]);
title('检测概率');
xlabel('雷达编号');
ylabel('检测概率');
ylim([0, 1]);
grid on;
set(gca, 'XTickLabel', radarIDs);
