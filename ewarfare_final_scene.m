function ewarfare_final_scene()
    % 电子战作战环境（最终增强版）
    % 功能包括：飞行平台侦察+干扰+打击，干扰波纹、爆炸效果、轨迹变色、阶段文字等
    clc;
    clear all;
    close all;

    N = 100;
    t = linspace(0, 1, N);
    x = 5000 * t;
    y = 2000 * t;
    z = [repmat(1000, 1, 60), linspace(1000, 0, 40)];
    traj = [x; y; z]';

    enemy_main = [5000, 2000, 0];
    enemy_pos = [enemy_main;
                 4800, 2500, 0;
                 5200, 1500, 0];
    labels = {'主辐射源', '干扰源1', '干扰源2'};

    fig = figure('Position', [100, 100, 1400, 700]);
    filename = 'ewarfare_final_scene.gif';

    for k = 1:N
        clf;
        hold on;
        axis equal;
        view(125, 30);
        xlim([0 5500]); ylim([0 3000]); zlim([0 1200]);
        xlabel('X (米)'); ylabel('Y (米)'); zlabel('高度 (米)');
        title('电子战动态作战环境');

        % 背景雷达感（浅灰色面板）
        set(gca, 'Color', [0.95 0.95 0.95]);

        % 敌方目标与标注
        scatter3(enemy_pos(:,1), enemy_pos(:,2), enemy_pos(:,3), ...
            100, [1 0 0; 1 0.5 0; 1 0.5 0], 'filled');
        for i = 1:3
            text(enemy_pos(i,1), enemy_pos(i,2), enemy_pos(i,3)+100, ...
                labels{i}, 'FontSize', 10, 'Color', 'k');
        end

        % 锁定图案（圆+十字）
        drawLock(enemy_main, 150);

        % 路径轨迹颜色渐变（蓝 -> 紫）
        for j = 2:k
            ratio = j / N;
            c = [0.2 + 0.6*ratio, 0.2, 1.0 - 0.6*ratio];
            plot3(traj(j-1:j,1), traj(j-1:j,2), traj(j-1:j,3), 'Color', c, 'LineWidth', 2);
        end

        % 当前飞行器
        curr = traj(k,:);
        scatter3(curr(1), curr(2), curr(3), 60, 'c', 'filled');

        % 阶段提示
        if k <= 60
            text(500, 2500, 1100, '阶段：无源侦察', 'FontSize', 12, 'Color', 'blue');
        else
            text(500, 2500, 1100, '阶段：主动干扰+探测', 'FontSize', 12, 'Color', 'red');
            % 雷达波束
            beam_angle = deg2rad(10);
            r = 3000;
            theta = linspace(-beam_angle, beam_angle, 15);
            for a = theta
                dx = r * cos(a); dy = r * sin(a);
                plot3([curr(1), curr(1)+dx], [curr(2), curr(2)+dy], [curr(3), curr(3)-500], ...
                    'Color', [0.6 0 1], 'LineWidth', 0.8);
            end
            drawRipples(curr, 'm', 0.3);
        end

        % 敌方反干扰波
        drawExpandingSpheres(enemy_pos(1,:), [1 0.5 0.5], 500, 4, k, 8, 0.3); % 敌方干扰源1
        drawExpandingSpheres(enemy_pos(2,:), [1 0.5 0], 500, 4, k, 8, 0.3); % 敌方干扰源1
        drawExpandingSpheres(enemy_pos(3,:), [1 0.5 0], 500, 4, k, 8, 0.3); % 敌方干扰源2

        if k > 60
            drawExpandingSpheres(curr, [0.6 0 1], 600, 5, k, 6, 0.4); % 我方干扰
        end

        % 爆炸命中（最后5帧）
        if k >= N - 5
            [xe, ye, ze] = sphere(20);
            R = 80 + 20 * sin((k - (N - 5)) * pi / 5);
            surf(enemy_main(1) + R*xe, enemy_main(2) + R*ye, enemy_main(3) + R*ze, ...
                'FaceColor', 'yellow', 'EdgeColor', 'none', 'FaceAlpha', 0.7);
        end

        % 时间进度文字
        text(100, 2800, 1150, sprintf('帧: %d / %d', k, N), ...
            'FontSize', 11, 'FontWeight', 'bold', 'Color', 'black');

        drawnow;

        frame = getframe(fig);
        img = frame2im(frame);
        [A, map] = rgb2ind(img, 256);
        if k == 1
            imwrite(A, map, filename, 'gif', 'LoopCount', Inf, 'DelayTime', 0.1);
        else
            imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
        end
    end

    disp(['✅ 动画保存为：', filename]);
end

function drawLock(center, r)
    theta = linspace(0, 2*pi, 100);
    cx = center(1) + r*cos(theta);
    cy = center(2) + r*sin(theta);
    cz = repmat(center(3)+20, size(cx));
    plot3(cx, cy, cz, 'r-', 'LineWidth', 1.5);
    l = r * 0.8;
    plot3([center(1)-l, center(1)+l], [center(2), center(2)], [center(3)+20, center(3)+20], 'r-', 'LineWidth', 1.2);
    plot3([center(1), center(1)], [center(2)-l, center(2)+l], [center(3)+20, center(3)+20], 'r-', 'LineWidth', 1.2);
end

function drawRipples(center, color, alpha)
    for i = 1:8
        angle = i * 2*pi/8;
        for d = linspace(200, 1000, 4)
            px = center(1) + d * cos(angle);
            py = center(2) + d * sin(angle);
            pz = 30 * sin(0.03 * d);
            plot3([center(1), px], [center(2), py], [center(3), pz], ...
                'Color', color, 'LineStyle', ':', 'LineWidth', 0.8);
        end
    end
end
%%
function drawExpandingSpheres(center, color, maxR, count, k, delay, alpha)
    hold on;
    [x, y, z] = sphere(20);
    for i = 1:count
        radius = maxR * mod((k - delay*i), count)/count;
        if radius <= 0
            continue;
        end
        c = color;
        surf(center(1)+radius*x, center(2)+radius*y, center(3)+radius*z, ...
            'EdgeColor', 'none', 'FaceAlpha', alpha * (1 - i/count), ...
            'FaceColor', c);
    end
end
