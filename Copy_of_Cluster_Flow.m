function [idx2] = Copy_of_Cluster_Flow(X1, X2, X3)
%% 优化后的聚类分析函数
% 输入：
%   X1, X2, X3 - 需要聚类的三组特征向量
% 输出：
%   idx2 - 聚类标签向量

%% 数据预处理
% 使用内置函数进行归一化，提高效率
XX1 = normalize(X1, 'range');  % Min-Max归一化到[0,1]
XX2 = normalize(X2, 'range');
XX3 = normalize(X3, 'range');
X = [XX1, XX2, XX3];

%% 三维数据可视化
figure('Name', '归一化特征分布', 'NumberTitle', 'off');
scatter3(X(:,1), X(:,2), X(:,3), 40, 'filled', 'MarkerFaceAlpha', 0.6);
grid on; box on;
xlabel('特征1 (归一化)'); ylabel('特征2 (归一化)'); zlabel('特征3 (归一化)');
title('特征空间分布');
view(45, 30);  % 设置更好的视角
colormap(jet);  % 使用彩色映射
colorbar;

%% 自动确定最佳聚类数
% 使用轮廓系数和Calinski-Harabasz指数综合评估
kRange = 2:10;
eva = evalclusters(X, 'kmeans', 'silhouette', 'klist', kRange);
chEva = evalclusters(X, 'kmeans', 'CalinskiHarabasz', 'klist', kRange);

% 综合两种指标确定最佳K值
scores = (eva.CriterionValues/max(eva.CriterionValues)) + ...
         (chEva.CriterionValues/max(chEva.CriterionValues));
[~, bestIdx] = max(scores);
K = kRange(bestIdx);

fprintf('最佳聚类数: %d (轮廓系数=%.2f, CH指数=%.2f)\n', ...
        K, eva.CriterionValues(bestIdx), chEva.CriterionValues(bestIdx));

%% 聚类分析
opts = statset('Display', 'final', 'MaxIter', 500);
[idx2, cen2] = kmeans(X, K, 'Distance', 'sqeuclidean', ...
                     'Replicates', 10, 'Options', opts);

%% 优化标签排序（按到原点的距离）
cenDist = sqrt(sum(cen2.^2, 2));  % 计算每个中心点到原点的距离
[~, sortIdx] = sort(cenDist, 'ascend');
idxMap = zeros(K, 1);
idxMap(sortIdx) = 1:K;  % 创建映射表
idx2 = idxMap(idx2);    % 应用新标签顺序

%% 聚类结果可视化
figure('Name', '聚类结果', 'NumberTitle', 'off');
hold on; grid on; box on;
view(45, 30);

% 创建更丰富的颜色映射
colors = lines(K);  % 使用lines颜色方案

% 绘制数据点
for i = 1:K
    clusterPoints = X(idx2 == i, :);
    scatter3(clusterPoints(:,1), clusterPoints(:,2), clusterPoints(:,3), ...
             50, colors(i,:), 'filled', 'MarkerFaceAlpha', 0.7);
end

% 绘制聚类中心
scatter3(cen2(:,1), cen2(:,2), cen2(:,3), 150, 'k', 'p', 'filled', ...
         'MarkerEdgeColor', 'w', 'LineWidth', 1.5);

% 添加标签和标题
xlabel('特征1'); ylabel('特征2'); zlabel('特征3');
title(sprintf('K-means聚类结果 (K=%d)', K));
legend([arrayfun(@(k) sprintf('类%d', k), 1:K, 'UniformOutput', false), {'中心点'}], ...
       'Location', 'bestoutside');

% 添加决策边界（2D投影）
figure('Name', '聚类边界投影', 'NumberTitle', 'off');
subplot(1, 3, 1);
gscatter(X(:,1), X(:,2), idx2, colors, '.', 15);
hold on;
plot(cen2(:,1), cen2(:,2), 'kp', 'MarkerSize', 12, 'LineWidth', 2);
title('特征1 vs 特征2');
xlabel('特征1'); ylabel('特征2');

subplot(1, 3, 2);
gscatter(X(:,2), X(:,3), idx2, colors, '.', 15);
hold on;
plot(cen2(:,2), cen2(:,3), 'kp', 'MarkerSize', 12, 'LineWidth', 2);
title('特征2 vs 特征3');
xlabel('特征2'); ylabel('特征3');

subplot(1, 3, 3);
gscatter(X(:,1), X(:,3), idx2, colors, '.', 15);
hold on;
plot(cen2(:,1), cen2(:,3), 'kp', 'MarkerSize', 12, 'LineWidth', 2);
title('特征1 vs 特征3');
xlabel('特征1'); ylabel('特征3');

%% 聚类质量评估
% 计算轮廓系数
silh = silhouette(X, idx2);
figure('Name', '聚类质量评估', 'NumberTitle', 'off');
subplot(1, 2, 1);
silhouette(X, idx2);
title(sprintf('轮廓系数 (均值=%.2f)', mean(silh)));

% 计算类内距离
withinClusterDist = zeros(K, 1);
for i = 1:K
    clusterPoints = X(idx2 == i, :);
    dists = pdist2(clusterPoints, cen2(i,:));
    withinClusterDist(i) = mean(dists);
end

subplot(1, 2, 2);
bar(withinClusterDist);
title('各类平均类内距离');
xlabel('类别');
ylabel('平均距离');
grid on;
end