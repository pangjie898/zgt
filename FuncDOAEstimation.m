function [DOAEstimation] = FuncDOAEstimation(PDWEstimationSignal, SamplingFrequency, ReceivingElementNum)
    % 参数校验
    if nargin < 3
        error('需要3个输入参数: PDWEstimationSignal, SamplingFrequency, ReceivingElementNum');
    end
    
    % 检查输入信号维度并确保正确格式
    [rows, cols] = size(PDWEstimationSignal);
    if rows == ReceivingElementNum
        % 正确格式：阵元数 x 快拍数
        SignalLength = cols;
    elseif cols == ReceivingElementNum
        % 需要转置：快拍数 x 阵元数 -> 阵元数 x 快拍数
        PDWEstimationSignal = PDWEstimationSignal';
        SignalLength = rows;
    else
        error('输入信号维度与阵元数不匹配');
    end
    
    if isempty(PDWEstimationSignal) || ReceivingElementNum <= 0
        DOAEstimation = NaN;
        return;
    end

    %% 参数设置
    SignalFrequency = SamplingFrequency;          % 使用输入参数作为载波频率
    Wavelength = 3e8 / SignalFrequency;           % 计算波长
    ElemenInterval = 0.5 * Wavelength;            % 半波长阵元间距
    
    %% 构造空间自相关矩阵
    AutocorrelationMatrix = (PDWEstimationSignal * PDWEstimationSignal') / SignalLength;
    
    %% 特征分解
    [U, S, ~] = svd(AutocorrelationMatrix);       % SVD分解
    eigenvalues = diag(S);                        % 提取特征值
    
    %% 估计信号数
    if length(eigenvalues) > 1
        diff_eigen = -diff(eigenvalues);          % 计算特征值差分（负差分）
        [~, idx] = max(diff_eigen);               % 找到最大差分位置
        SourceNum = min(idx, ReceivingElementNum - 1); % 确保信号数有效
    else
        SourceNum = 1;  % 单阵元情况
    end
    
    %% 构造噪声子空间
    if SourceNum < ReceivingElementNum
        Un = U(:, SourceNum+1:end); % 噪声子空间向量
    else
        Un = U(:, end); % 处理边界情况
    end
    
    %% MUSIC谱计算
    searching_doa = -90 : 0.1 : 90;               % 角度搜索范围
    Pmusic = zeros(1, length(searching_doa));      % 初始化谱向量
    
    for i = 1 : length(searching_doa)
        % 构造导向矢量
        theta_rad = deg2rad(searching_doa(i));     % 角度转弧度
        phase_shift = 2 * pi * ElemenInterval * sin(theta_rad) / Wavelength;
        a_theta = exp(-1j * (0 : ReceivingElementNum - 1)' * phase_shift);
        
        % 修复维度问题：确保Un'和a_theta维度兼容
        proj = Un' * a_theta;
        Pmusic(i) = 1 / (proj' * proj + eps);     % 防止除零
    end
    
    %% 峰值搜索与DOA估计
    [~, peak_idx] = max(abs(Pmusic));              % 找到主峰位置
    DOAEstimation = searching_doa(peak_idx);       % 直接获取对应角度
end