function [AntennaScanningAmplitude] = FuncAntennaScanning(...
    ScanningType, AmplitudeStabilityCoefficient, AntennaScanningCycle, ...
    SamplingFrequency, AntennaPatternFunctionType, ...
    MaxAngleOfTargetDeviationFromAntennaAxis, ProportionalConstant, ...
    HalfPowerBeamWidth, ZeroPowerBeamWidth)
    
    % 计算时间轴
    fs = SamplingFrequency;
    t = 0:1/fs:AntennaScanningCycle-1/fs;
    theta_max = MaxAngleOfTargetDeviationFromAntennaAxis;
    
    % 根据扫描类型计算角度变化
    switch ScanningType
        case {1, 2} % 圆周扫描和圆锥扫描
            theta_t = theta_max * sin(2*pi*t/AntennaScanningCycle);
        case 3 % 扇形扫描
            theta_t = theta_max * sawtooth(2*pi*t/AntennaScanningCycle, 0.5);
        case 4 % 连续照射
            theta_t = zeros(size(t)); % 目标在轴线中心
        otherwise
            error('不支持的扫描类型');
    end
    
    % 计算天线方向图函数（避免除零错误）
    switch AntennaPatternFunctionType
        case 1 % 余弦函数
            G = cos(ProportionalConstant * theta_t / HalfPowerBeamWidth);
        case 2 % 高斯函数
            G = exp(-ProportionalConstant * (theta_t / HalfPowerBeamWidth).^2);
        case 3 % 辛克函数
            % 处理theta_t=0的情况避免除零
            idx = abs(theta_t) < eps;
            G = ones(size(theta_t));
            G(~idx) = sin(ProportionalConstant * theta_t(~idx) / ZeroPowerBeamWidth) ./ ...
                      (ProportionalConstant * theta_t(~idx) / ZeroPowerBeamWidth);
        otherwise
            error('不支持的天线方向图类型');
    end
    
    % 应用幅度稳定系数
    AntennaScanningAmplitude = AmplitudeStabilityCoefficient * abs(G);
end