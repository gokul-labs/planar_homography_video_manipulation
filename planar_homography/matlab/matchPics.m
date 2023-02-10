function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

I1_gray = I1;
I2_gray = I2;
%% Convert images to grayscale, if necessary
if size(size(I1), 2) == 3
    I1_gray = rgb2gray(I1_gray);
end

if size(size(I2), 2) == 3
    I2_gray = rgb2gray(I2_gray);
end

%% Detect features in both images
fast_features_I1 = detectFASTFeatures(I1_gray);
fast_features_I2 = detectFASTFeatures(I2_gray);

%% Obtain descriptors for the computed feature locations
[desc_I1, locs_I1] = computeBrief(I1_gray, fast_features_I1.Location);
[desc_I2, locs_I2] = computeBrief(I2_gray, fast_features_I2.Location);

%% Match features using the descriptors
matched_features = matchFeatures(desc_I1, desc_I2, 'MatchThreshold', 10.0, 'MaxRatio', 0.7);
matched_indices_I1 = matched_features(:,1);
matched_indices_I2 = matched_features(:,2);
matched_locs_I1 = locs_I1(matched_indices_I1, :);
matched_locs_I2 = locs_I2(matched_indices_I2, :);

locs1 = matched_locs_I1;
locs2 = matched_locs_I2;
end

