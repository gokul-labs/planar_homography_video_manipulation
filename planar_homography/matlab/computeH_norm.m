function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = mean(x1);
centroid2 = mean(x2);

%% Shift the origin of the points to the centroid

shifted_x1 = x1 - centroid1;
shifted_x2 = x2 - centroid2;

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).

distance_from_origin = 0;
for i=1:size(shifted_x1, 1)
    point = shifted_x1(i,:);
    distance_from_origin = distance_from_origin + (sqrt((point(1)^2) + (point(2)^2)));
end
mean_dist_from_origin_x1 = distance_from_origin / size(shifted_x1, 1);

distance_from_origin = 0;
for i=i:size(shifted_x2, 1)
    point = shifted_x2(i,:);
    distance_from_origin = distance_from_origin + (sqrt((point(1)^2) + (point(2)^2)));
end
mean_dist_from_origin_x2 = distance_from_origin / size(shifted_x2, 1);

norm_x1 = (sqrt(2) / mean_dist_from_origin_x1) * shifted_x1;
norm_x2 = (sqrt(2) / mean_dist_from_origin_x2) * shifted_x2;

%% similarity transform 1
T1 = [
    (sqrt(2) / mean_dist_from_origin_x1), 0, -centroid1(1) * (sqrt(2) / mean_dist_from_origin_x1)
    0, (sqrt(2) / mean_dist_from_origin_x1), -centroid1(2) * (sqrt(2) / mean_dist_from_origin_x1)
    0, 0, 1
];


%% similarity transform 2
T2 = [
    (sqrt(2) / mean_dist_from_origin_x2), 0, -centroid2(1) * (sqrt(2) / mean_dist_from_origin_x2)
    0, (sqrt(2) / mean_dist_from_origin_x2), -centroid2(2) * (sqrt(2) / mean_dist_from_origin_x2)
    0, 0, 1
];

%% Compute Homography
H2to1 = computeH(norm_x1, norm_x2);
%% Denormalization
H2to1 = T1 \ H2to1 * T2;
end
