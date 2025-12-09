classdef EWEnvironment < handle
    properties
        % 图形对象
        fig
        ax
        
        % 我方平台参数
        myPlatformPos
        myPlatformTrajectory
        trajectoryIndex = 1
        platformSpeed = 0.5
        
        % 导弹参数
        missilePos
        missileTrajectory
        missileLaunched = false
        missileTime = 0
        
        % 敌方辐射源参数 (单位：千米)
        enemyEmitters = [
            45, 50, 0;    % 主辐射源 (地面)
            40, 55, 0;    % 辐射源2 (地面)
            50, 45, 0     % 辐射源3 (地面)
        ];
        
        % 阶段控制
        currentPhase = 1; % 1:侦察, 2:干扰/探测, 3:导弹攻击
        reconCompleteTime = 15;  % 侦察阶段持续时间(秒)
        currentTime = 0;
        
        % 图形句柄
        platformHandle
        missileHandle
        emitterHandles
        reconLines
        jammerLines
        detectionLines
        jammerSphere
        interferenceSpheres
        infoText
        terrain
        explosion
        
        % 颜色定义
        colors = struct(...
            'platform', [0.2 0.6 1], ...      % 蓝色 - 我方平台
            'missile', [1 0.8 0.2], ...       % 黄色 - 导弹
            'mainEmitter', [1 0.1 0.1], ...   % 红色 - 主辐射源
            'otherEmitter', [1 0.6 0.2], ...  % 橙色 - 其他辐射源
            'recon', [0.3 0.9 0.3], ...      % 绿色 - 侦察信号
            'jammer', [1 0.4 0.1], ...       % 橙色 - 干扰信号
            'detection', [1 0.9 0.3], ...    % 黄色 - 探测信号
            'interference', [0.8 0.3 0.8], ... % 紫色 - 敌方干扰
            'terrain', [0.35 0.7 0.35], ...  % 绿色 - 地形
            'explosion', [1 0.8 0] ...       % 金色 - 爆炸
        );
    end
    
    methods
        function obj = EWEnvironment()
            % 初始化图形窗口
            obj.fig = figure('Name', '电子战3D作战环境', 'NumberTitle', 'off', ...
                'Position', [50 50 1400 850], 'Color', 'k');
            obj.ax = axes('Parent', obj.fig, 'Color', 'k', ...
                'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
            
            % 设置3D视图
            axis equal;
            grid on;
            xlim([0 100]);
            ylim([0 100]);
            zlim([0 12]);
            view(35, 25);  % 3D视角
            title('电子战3D动态作战环境', 'Color', 'w', 'FontSize', 18, 'FontWeight', 'bold');
            xlabel('X方向 (km)', 'FontSize', 12);
            ylabel('Y方向 (km)', 'FontSize', 12);
            zlabel('高度 (km)', 'FontSize', 12);
            
            % 创建地形
            obj.createTerrain();
            
            % 初始化平台轨迹 (3D路径 - 平滑曲线)
            t = linspace(0, 1, 150);
            x_traj = 10 + 85*t;
            y_traj = 90 - 80*t.^1.5;
            z_traj = 8 - 5*t.^2;  % 高度从8km平滑下降到3km
            
            obj.myPlatformTrajectory = [x_traj; y_traj; z_traj];
            
            % 初始位置
            obj.myPlatformPos = obj.myPlatformTrajectory(:, 1);
            
            % 绘制敌方辐射源
            obj.drawEmitters();
            
            % 绘制我方平台 (导引头)
            hold on;
            [x, y, z] = ellipsoid(0,0,0, 2,1,1, 20);
            obj.platformHandle = surf(obj.ax, ...
                x + obj.myPlatformPos(1), ...
                y + obj.myPlatformPos(2), ...
                z + obj.myPlatformPos(3), ...
                'FaceColor', obj.colors.platform, ...
                'EdgeColor', 'none', ...
                'FaceAlpha', 0.9);
            
            % 添加平台轨迹
            plot3(obj.ax, obj.myPlatformTrajectory(1,:), ...
                obj.myPlatformTrajectory(2,:), ...
                obj.myPlatformTrajectory(3,:), ...
                '--', 'Color', [0.7 0.8 1], 'LineWidth', 1.5);
            
            % 初始化导弹位置
            obj.missilePos = [0; 0; 0];
            [x_m, y_m, z_m] = ellipsoid(0,0,0, 0.5,0.5,1, 15);
            obj.missileHandle = surf(obj.ax, ...
                x_m, y_m, z_m, ...
                'FaceColor', obj.colors.missile, ...
                'EdgeColor', 'none', ...
                'FaceAlpha', 0);
            
            % 添加图例 - 修复颜色错误
            legendItems = gobjects(1, 10);
            legendItems(1) = plot3(obj.ax, NaN, NaN, NaN, 'o', 'Color', obj.colors.mainEmitter, ...
                'MarkerFaceColor', obj.colors.mainEmitter, 'MarkerSize', 10);
            legendItems(2) = plot3(obj.ax, NaN, NaN, NaN, 'o', 'Color', obj.colors.otherEmitter, ...
                'MarkerFaceColor', obj.colors.otherEmitter, 'MarkerSize', 10);
            legendItems(3) = plot3(obj.ax, NaN, NaN, NaN, 's', 'Color', obj.colors.platform, ...
                'MarkerFaceColor', obj.colors.platform, 'MarkerSize', 10);
            legendItems(4) = plot3(obj.ax, NaN, NaN, NaN, 'd', 'Color', obj.colors.missile, ...
                'MarkerFaceColor', obj.colors.missile, 'MarkerSize', 10);
            legendItems(5) = plot3(obj.ax, NaN, NaN, NaN, '--', 'Color', obj.colors.recon, 'LineWidth', 2);
            legendItems(6) = plot3(obj.ax, NaN, NaN, NaN, '-', 'Color', obj.colors.jammer, 'LineWidth', 2);
            legendItems(7) = plot3(obj.ax, NaN, NaN, NaN, '-', 'Color', obj.colors.detection, 'LineWidth', 3);
            
            % 修复：使用RGB颜色而不是RGBA
            legendItems(8) = plot3(obj.ax, NaN, NaN, NaN, 'o', 'Color', obj.colors.jammer, ...
                'MarkerFaceColor', obj.colors.jammer, 'MarkerSize', 10);
            legendItems(9) = plot3(obj.ax, NaN, NaN, NaN, 'o', 'Color', obj.colors.interference, ...
                'MarkerFaceColor', obj.colors.interference, 'MarkerSize', 10);
            
            legendItems(10) = plot3(obj.ax, NaN, NaN, NaN, '*', 'Color', obj.colors.explosion, ...
                'MarkerFaceColor', obj.colors.explosion, 'MarkerSize', 15);
            
            legend(legendItems, {
                '敌方主辐射源', 
                '敌方辐射源', 
                '我方电子战平台', 
                '精确制导导弹', 
                '无源侦察信号', 
                '定向干扰信号', 
                '精准探测信号', 
                '我方全向干扰', 
                '敌方干扰场', 
                '目标摧毁'
            }, 'TextColor', 'w', 'Location', 'northeastoutside', 'FontSize', 10, 'Box', 'off');
            
            % 添加信息文本框
            obj.infoText = annotation('textbox', [0.02, 0.02, 0.4, 0.1], ...
                'String', '作战阶段: 无源侦察 (远距离探测辐射源信号)', ...
                'Color', 'w', 'BackgroundColor', 'k', ...
                'EdgeColor', 'y', 'FontSize', 12, 'FitBoxToText', 'on', ...
                'LineWidth', 2, 'FontWeight', 'bold');
            
            % 初始化干扰场
            obj.interferenceSpheres = gobjects(1, 3);
            for i = 1:3
                % 创建上半球体表示地面以上的干扰
                [x, y, z] = sphere(20);
                z(z < 0) = 0;  % 只保留上半球
                
                obj.interferenceSpheres(i) = surf(obj.ax, ...
                    obj.enemyEmitters(i,1) + x*3, ...
                    obj.enemyEmitters(i,2) + y*3, ...
                    obj.enemyEmitters(i,3) + z*3, ...
                    'FaceAlpha', 0.15, 'EdgeColor', 'none', ...
                    'FaceColor', obj.colors.interference);
            end
            
            % 初始化我方干扰球
            [x, y, z] = sphere(15);
            obj.jammerSphere = surf(obj.ax, ...
                NaN*x, NaN*y, NaN*z, ...
                'FaceAlpha', 0.1, 'EdgeColor', 'none', ...
                'FaceColor', obj.colors.jammer);
            
            % 初始化爆炸效果
            obj.explosion = plot3(obj.ax, NaN, NaN, NaN, ...
                '*', 'MarkerSize', 1, 'Color', obj.colors.explosion, ...
                'LineWidth', 2);
            
            % 初始化信号线
            obj.reconLines = gobjects(1, 3);
            obj.jammerLines = gobjects(0);
            obj.detectionLines = gobjects(0);
            
            % 添加光源
            light('Position', [30 40 20], 'Style', 'local', 'Color', [1 1 0.8]);
            light('Position', [70 60 15], 'Style', 'local', 'Color', [0.8 0.8 1]);
            lighting gouraud;
            material shiny;
            
            % 开始动画
            obj.runSimulation();
        end
        
        function createTerrain(obj)
            % 创建详细地形
            [X, Y] = meshgrid(0:1:100, 0:1:100);
            Z = zeros(size(X));
            
            % 添加地形特征
            Z = 0.5*sin(X/15) + 0.3*cos(Y/12) + ...
                0.2*sin(X/5 + Y/7) + ...
                0.1*exp(-((X-40).^2 + (Y-50).^2)/500) - ...
                0.1*exp(-((X-70).^2 + (Y-30).^2)/300);
            
            obj.terrain = surf(obj.ax, X, Y, Z, ...
                'FaceColor', obj.colors.terrain, ...
                'EdgeColor', 'none', ...
                'FaceAlpha', 0.8);
        end
        
        function drawEmitters(obj)
            hold on;
            obj.emitterHandles = gobjects(1, 3);
            for i = 1:3
                if i == 1
                    color = obj.colors.mainEmitter;
                    size = 16;
                else
                    color = obj.colors.otherEmitter;
                    size = 12;
                end
                
                % 绘制辐射塔基座
                [x, y, z] = cylinder([0.8 0.6 0.4], 20);
                z = z * 3;  % 高度缩放
                base = surf(obj.ax, ...
                    obj.enemyEmitters(i,1) + x, ...
                    obj.enemyEmitters(i,2) + y, ...
                    obj.enemyEmitters(i,3) + z, ...
                    'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none');
                
                % 添加天线
                [x, y, z] = cylinder([0.3 0.1], 12);
                z = z * 4 + 3;  % 在基座上方
                antenna = surf(obj.ax, ...
                    obj.enemyEmitters(i,1) + x, ...
                    obj.enemyEmitters(i,2) + y, ...
                    obj.enemyEmitters(i,3) + z, ...
                    'FaceColor', [0.7 0.7 0.7], 'EdgeColor', 'none');
                
                % 添加辐射源标志
                obj.emitterHandles(i) = plot3(obj.ax, ...
                    obj.enemyEmitters(i,1), obj.enemyEmitters(i,2), obj.enemyEmitters(i,3)+7, ...
                    'o', 'MarkerSize', size, 'MarkerFaceColor', color, ...
                    'MarkerEdgeColor', 'w', 'LineWidth', 1.5);
            end
        end
        
        function updateInterference(obj)
            % 更新敌方干扰场 - 动态效果
            for i = 1:3
                % 脉动效果
                radius = 4 + sin(obj.currentTime*2 + i) * 0.5;
                
                % 获取上半球
                [x, y, z] = sphere(20);
                z(z < 0) = 0;  % 只保留上半球
                
                set(obj.interferenceSpheres(i), ...
                    'XData', obj.enemyEmitters(i,1) + x*radius, ...
                    'YData', obj.enemyEmitters(i,2) + y*radius, ...
                    'ZData', obj.enemyEmitters(i,3) + z*radius);
                
                % 动态改变透明度
                alpha = 0.1 + abs(sin(obj.currentTime*3 + i)) * 0.1;
                set(obj.interferenceSpheres(i), 'FaceAlpha', alpha);
            end
        end
        
        function updateJammerSphere(obj)
            % 更新我方全向干扰球
            radius = 8 + sin(obj.currentTime*3) * 1;
            
            [x, y, z] = sphere(15);
            set(obj.jammerSphere, ...
                'XData', obj.myPlatformPos(1) + x*radius, ...
                'YData', obj.myPlatformPos(2) + y*radius, ...
                'ZData', obj.myPlatformPos(3) + z*radius);
            
            % 动态改变透明度
            alpha = 0.08 + abs(sin(obj.currentTime*4)) * 0.07;
            set(obj.jammerSphere, 'FaceAlpha', alpha);
        end
        
        function runSimulation(obj)
            % 设置动画循环
            while ishandle(obj.fig)
                % 更新时间
                obj.currentTime = obj.currentTime + 0.1;
                pause(0.05);
                
                % 更新平台位置
                if obj.trajectoryIndex < size(obj.myPlatformTrajectory, 2)
                    obj.trajectoryIndex = obj.trajectoryIndex + 1;
                    obj.myPlatformPos = obj.myPlatformTrajectory(:, obj.trajectoryIndex);
                    
                    % 更新平台模型位置
                    [x, y, z] = ellipsoid(0,0,0, 2,1,1, 20);
                    set(obj.platformHandle, ...
                        'XData', x + obj.myPlatformPos(1), ...
                        'YData', y + obj.myPlatformPos(2), ...
                        'ZData', z + obj.myPlatformPos(3));
                end
                
                % 更新干扰场
                obj.updateInterference();
                
                % 检查阶段转换
                if obj.currentPhase == 1 && obj.currentTime > obj.reconCompleteTime
                    obj.currentPhase = 2;
                    set(obj.infoText, 'String', '作战阶段: 干扰与精准探测 (释放全向干扰，引导精确制导)');
                    set(obj.infoText, 'EdgeColor', 'r');
                    
                    % 清除侦察信号
                    delete(obj.reconLines);
                    
                    % 准备导弹发射
                    obj.missilePos = obj.myPlatformPos;
                    set(obj.missileHandle, 'FaceAlpha', 1);
                end
                
                % 导弹发射逻辑
                if obj.currentPhase == 2 && ~obj.missileLaunched && obj.currentTime > obj.reconCompleteTime + 5
                    obj.missileLaunched = true;
                    obj.missileTime = 0;
                    
                    % 创建导弹轨迹 (抛物线)
                    t_missile = linspace(0, 1, 80);
                    startPos = obj.missilePos;
                    targetPos = [obj.enemyEmitters(1,1); obj.enemyEmitters(1,2); 7];
                    
                    % 抛物线轨迹
                    obj.missileTrajectory = [
                        startPos(1) + (targetPos(1)-startPos(1))*t_missile;
                        startPos(2) + (targetPos(2)-startPos(2))*t_missile;
                        startPos(3) + (targetPos(3)-startPos(3))*t_missile + ...
                        20*sin(pi*t_missile)  % 抛物线高度
                    ];
                end
                
                % 更新导弹位置
                if obj.missileLaunched
                    obj.missileTime = min(obj.missileTime + 0.5, size(obj.missileTrajectory, 2));
                    obj.missilePos = obj.missileTrajectory(:, floor(obj.missileTime));
                    
                    [x_m, y_m, z_m] = ellipsoid(0,0,0, 0.5,0.5,1, 15);
                    set(obj.missileHandle, ...
                        'XData', x_m + obj.missilePos(1), ...
                        'YData', y_m + obj.missilePos(2), ...
                        'ZData', z_m + obj.missilePos(3));
                    
                    % 检查是否命中目标
                    distToTarget = norm(obj.missilePos - [obj.enemyEmitters(1,1); obj.enemyEmitters(1,2); 7]);
                    if distToTarget < 3 && obj.currentPhase ~= 3
                        obj.currentPhase = 3;
                        set(obj.infoText, 'String', '作战阶段: 目标摧毁 (主辐射源已被精确制导导弹摧毁)');
                        set(obj.infoText, 'EdgeColor', [1 0.5 0]);
                        
                        % 创建爆炸效果
                        theta = linspace(0, 2*pi, 50);
                        r = linspace(0, 8, 10);
                        [T, R] = meshgrid(theta, r);
                        X = obj.enemyEmitters(1,1) + R.*cos(T);
                        Y = obj.enemyEmitters(1,2) + R.*sin(T);
                        Z = 7 + abs(randn(size(X)))*2;
                        
                        set(obj.explosion, 'XData', X(:), 'YData', Y(:), 'ZData', Z(:), ...
                            'Marker', '*', 'MarkerSize', 8, 'LineWidth', 1.5);
                        
                        % 隐藏主辐射源
                        set(obj.emitterHandles(1), 'Visible', 'off');
                        set(obj.interferenceSpheres(1), 'Visible', 'off');
                    end
                end
                
                % 根据阶段更新信号显示
                switch obj.currentPhase
                    case 1 % 侦察阶段
                        obj.drawReconSignals();
                    case 2 % 干扰/探测阶段
                        obj.drawJammerSignals();
                        obj.drawDetectionSignal();
                        obj.updateJammerSphere(); % 更新全向干扰球
                    case 3 % 导弹攻击阶段
                        % 保持干扰和探测显示
                        obj.drawJammerSignals();
                        obj.drawDetectionSignal();
                        obj.updateJammerSphere();
                end
                drawnow;
            end
        end
        
        function drawReconSignals(obj)
            % 清除之前的信号
            if ~isempty(obj.reconLines) && all(isgraphics(obj.reconLines))
                delete(obj.reconLines);
            end
            
            % 绘制侦察信号 (从辐射源到平台)
            obj.reconLines = gobjects(1, 3);
            for i = 1:3
                % 计算信号路径
                x = [obj.enemyEmitters(i,1), obj.myPlatformPos(1)];
                y = [obj.enemyEmitters(i,2), obj.myPlatformPos(2)];
                z = [obj.enemyEmitters(i,3)+7, obj.myPlatformPos(3)];
                
                % 创建带箭头的线
                obj.reconLines(i) = plot3(obj.ax, x, y, z, '--', ...
                    'Color', [obj.colors.recon, 0.7], 'LineWidth', 1.5);
                
                % 添加箭头
                arrowPos = [x(1)+(x(2)-x(1))*0.8, y(1)+(y(2)-y(1))*0.8, z(1)+(z(2)-z(1))*0.8];
                plot3(obj.ax, arrowPos(1), arrowPos(2), arrowPos(3), '>', ...
                    'MarkerSize', 8, 'MarkerFaceColor', obj.colors.recon, ...
                    'MarkerEdgeColor', 'none');
            end
        end
        
        function drawJammerSignals(obj)
            % 清除之前的信号
            if ~isempty(obj.jammerLines) && all(isgraphics(obj.jammerLines))
                delete(obj.jammerLines);
            end
            
            % 对主辐射源实施干扰
            x = [obj.myPlatformPos(1), obj.enemyEmitters(1,1)];
            y = [obj.myPlatformPos(2), obj.enemyEmitters(1,2)];
            z = [obj.myPlatformPos(3), obj.enemyEmitters(1,3)+7];
            
            % 创建干扰信号束 (锥形)
            coneRes = 20;
            [X, Y, Z] = cylinder([0.2 0.8], coneRes);
            Z = Z * norm([x(2)-x(1), y(2)-y(1), z(2)-z(1)]); % 缩放长度
            
            % 旋转锥体到正确方向
            direction = [x(2)-x(1), y(2)-y(1), z(2)-z(1)];
            direction = direction / norm(direction);
            
            % 创建旋转矩阵
            [~, ~, V] = svd([direction; null(direction)]);
            rotation = V(:, [2 3 1]);
            
            % 应用旋转
            for i = 1:size(X,1)
                for j = 1:size(X,2)
                    vec = rotation * [X(i,j); Y(i,j); Z(i,j)];
                    X(i,j) = vec(1);
                    Y(i,j) = vec(2);
                    Z(i,j) = vec(3);
                end
            end
            
            % 平移锥体
            X = X + obj.myPlatformPos(1);
            Y = Y + obj.myPlatformPos(2);
            Z = Z + obj.myPlatformPos(3);
            
            % 绘制干扰锥
            obj.jammerLines = surf(obj.ax, X, Y, Z, ...
                'FaceColor', obj.colors.jammer, 'EdgeColor', 'none', ...
                'FaceAlpha', 0.4);
        end
        
        function drawDetectionSignal(obj)
            % 清除之前的信号
            if ~isempty(obj.detectionLines) && all(isgraphics(obj.detectionLines))
                delete(obj.detectionLines);
            end
            
            % 对主辐射源实施精准探测
            x = [obj.myPlatformPos(1), obj.enemyEmitters(1,1)];
            y = [obj.myPlatformPos(2), obj.enemyEmitters(1,2)];
            z = [obj.myPlatformPos(3), obj.enemyEmitters(1,3)+7];
            
            % 创建探测信号束 (窄锥体)
            coneRes = 20;
            [X, Y, Z] = cylinder([0.1 0.3], coneRes);
            Z = Z * norm([x(2)-x(1), y(2)-y(1), z(2)-z(1)]); % 缩放长度
            
            % 旋转锥体到正确方向
            direction = [x(2)-x(1), y(2)-y(1), z(2)-z(1)];
            direction = direction / norm(direction);
            
            % 创建旋转矩阵
            [~, ~, V] = svd([direction; null(direction)]);
            rotation = V(:, [2 3 1]);
            
            % 应用旋转
            for i = 1:size(X,1)
                for j = 1:size(X,2)
                    vec = rotation * [X(i,j); Y(i,j); Z(i,j)];
                    X(i,j) = vec(1);
                    Y(i,j) = vec(2);
                    Z(i,j) = vec(3);
                end
            end
            
            % 平移锥体
            X = X + obj.myPlatformPos(1);
            Y = Y + obj.myPlatformPos(2);
            Z = Z + obj.myPlatformPos(3);
            
            % 绘制精确探测光束
            obj.detectionLines = surf(obj.ax, X, Y, Z, ...
                'FaceColor', obj.colors.detection, 'EdgeColor', 'none', ...
                'FaceAlpha', 0.5);
        end
    end
end