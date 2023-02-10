function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

preset_threshold = 1;
previous_best_inlier_count = -1;
bestH2to1 = "";

for i = 1:2500
    % take minimum 4 points
    rand_indices = randperm(size(locs1, 1), 4);
    H2to1 = computeH_norm(locs1(rand_indices, :), locs2(rand_indices, :));
    inliers_temp = zeros(size(locs1, 1), 1);

    for n = 1:size(locs1,1)
        I2_point = [locs2(n,:)];  
        % make homogenous
        I2_point(end+1) = 1;
        I2_point = I2_point';
        transformed_point = H2to1 * I2_point;
        % make heterogenous
        heterogenous_I1_point = [transformed_point(1)/transformed_point(3) transformed_point(2)/transformed_point(3)];
        L2_distance = sqrt((transformed_point(1)-locs1(n, 1))^2 + (transformed_point(2) - locs1(n, 2))^2);
        if (L2_distance < preset_threshold)
            inliers_temp(n) = 1;
        end
    end

    inliers_count = sum(inliers_temp, 'all');
    if inliers_count > previous_best_inlier_count
        previous_best_inlier_count = inliers_count;
        bestH2to1 = H2to1;
        inliers = inliers_temp;
    end
end

