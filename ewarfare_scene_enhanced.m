function ewarfare_final_scene()
    % 电子战动态作战环境（终极增强版）
    % 包含：平台飞行/雷达波束/波纹干扰/阶段提示/地形背景

    %% 参数设置
    N = 100;
    t = linspace(0, 1, N);
    x = 5000 * t;
    y = 2000 * t;
    z = [repmat(1000, 1, 60), linspace(1000, 0, 40)];  % 先平飞，再下降
    traj = [x; y; z]';

    enemy_pos = [5000, 2000, 0;
                 4800, 2500, 0;
                 5200, 1500, 0];
    labels = {'主辐射源', '干扰源1', '干扰源2'};
    gifname = 'ewarfare_final_scene.gif';

    %% 创建图像
    fig = figure('Position', [100, 100, 900, 700]);

    for k = 1:N
        clf;
        hold on;
        axis equal;
        view(125, 30);
        xlim([0 5500]); ylim([0 3000]); zlim([0 1200]);
        xlabel('X (米)'); ylabel('Y (米)'); zlabel('高度 (米)');
        title('电子战动态作战场景（增强版）');

        % 三维地形背景
        [Xg, Yg] = meshgrid(linspace(0, 5500, 40), linspace(0, 3000, 30));
        Zg = 50 * sin(2*pi*Xg/5500) .* cos(2*pi*Yg/3000);
        surf(Xg, Yg, Zg, 'EdgeColor', 'none', 'FaceAlpha', 0.5, 'FaceColor', 'interp');
        colormap('terrain');

        % 敌方目标标注
        scatter3(enemy_pos(:,1), enemy_pos(:,2), enemy_pos(:,3), ...
            100, [1 0 0; 1 0.5 0; 1 0.5 0], 'filled');
        for i = 1:3
            text(enemy_pos(i,1), enemy_pos(i,2), enemy_pos(i,3)+100, ...
                labels{i}, 'FontSize', 10, 'Color', 'k');
        end

        % 我方轨迹与平台
        plot3(traj(1:k,1), traj(1:k,2), traj(1:k,3), 'b-', 'LineWidth', 2);
        curr = traj(k,:);
        scatter3(curr(1), curr(2), curr(3), 60, 'c', 'filled');

        % 阶段标注
        if k <= 60
            text(500, 2500, 1100, '阶段：无源侦察（水平飞行）', 'FontSize', 12, 'Color', 'blue');
        else
            text(500, 2500, 1100, '阶段：主动干扰 + 探测', 'FontSize', 12, 'Color', 'purple');

            % 雷达波束可视化（10度扇形）
            beam_angle = deg2rad(10);
            r = 3000;
            theta = linspace(-beam_angle, beam_angle, 20);
            for a = theta
                dx = r * cos(a);
                dy = r * sin(a);
                plot3([curr(1), curr(1)+dx], ...
                      [curr(2), curr(2)+dy], ...
                      [curr(3), curr(3)-500], ...
                      'Color', [0.6 0 1], 'LineWidth', 0.8, 'LineStyle', '-');
            end

            % 波纹干扰（8方向）
            for i = 1:8
                angle = i * (2*pi/8);
                for d = linspace(200, 1000, 5)
                    px = curr(1) + d * cos(angle);
                    py = curr(2) + d * sin(angle);
                    r_dist = norm([px - curr(1), py - curr(2)]);
                    pz = 30 * sin(0.03 * r_dist);
                    plot3([curr(1), px], [curr(2), py], [curr(3), pz], ...
                          'Color', 'magenta', 'LineStyle', ':', 'LineWidth', 0.8);
                end
            end
        end

        drawnow;

        % 写入GIF
        frame = getframe(fig);
        img = frame2im(frame);
        [A, map] = rgb2ind(img, 256);
        if k == 1
            imwrite(A, map, gifname, 'gif', 'LoopCount', Inf, 'DelayTime', 0.1);
        else
            imwrite(A, map, gifname, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
        end
    end

    disp(['GIF动画已保存为：' gifname]);
end
