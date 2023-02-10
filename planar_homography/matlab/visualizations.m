%Visualize computeH outputs

I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png');

% I have experimented using the BRIEF and SURF for visualizations

% For BRIEF, uncomment this and set USE_BRIEF flag to 0
[matched_locs_I1, matched_locs_I2] = matchPics(I1, I2);

% For SURF, uncomment line 12 to 28 and set USE_SURF flag to 1
% I1_gray = I1;
% if size(size(I1_gray), 2) == 3
%     I1_gray = rgb2gray(I1_gray);
% end
% I2_gray = I2;
% if size(size(I2_gray), 2) == 3
%     I2_gray = rgb2gray(I2_gray);
% end
% fast_features_I1 = detectSURFFeatures(I1_gray);
% [desc_I1, locs_I1] = extractFeatures(I1_gray, fast_features_I1.Location, 'Method', 'SURF');
% fast_features_I2 = detectSURFFeatures(I2_gray);
% [desc_I2, locs_I2] = extractFeatures(I2_gray, fast_features_I2.Location, 'Method', 'SURF');
% matched_features = matchFeatures(desc_I1, desc_I2, 'MatchThreshold', 10.0, 'MaxRatio', 0.7);
% matched_indices_I1 = matched_features(:,1);
% matched_indices_I2 = matched_features(:,2);
% matched_locs_I1 = locs_I1(matched_indices_I1, :);
% matched_locs_I2 = locs_I2(matched_indices_I2, :);


%% Comment uncomment as required to choose the visualization type
%% Also set the flag USE_SURF to 0 or 1 
USE_SURF = 0;
if USE_SURF == 1
    matched_locs_I1 = matched_locs_I1.Location;
    matched_locs_I2 = matched_locs_I2.Location;
end

% H2to1 = computeH(matched_locs_I1, matched_locs_I2);
% H2to1 = computeH_norm(matched_locs_I1, matched_locs_I2);
H2to1 = computeH_ransac(matched_locs_I1, matched_locs_I2);

% rng('shuffle')
vis_indices = randperm(size(matched_locs_I2, 1), 10);
heterogenous_I1_points = zeros(10,2);
count = 1;
for i = vis_indices
    I2_point = [matched_locs_I2(i,:)];  
    % make homogenous
    I2_point(end+1) = 1;
    I2_point = I2_point';
    I1_point = H2to1 * I2_point;
    % make heterogenous
    heterogenous_I1_point = [I1_point(1)/I1_point(3) I1_point(2)/I1_point(3)]; 
    heterogenous_I1_points(count, :) = heterogenous_I1_point;
    count = count+1;
end

showMatchedFeatures(I1, I2, heterogenous_I1_points, matched_locs_I2(vis_indices, :), 'montage');