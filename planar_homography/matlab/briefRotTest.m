% Your solution to Q2.1.5 goes here!

% BRIEF Section

%% Read the image and convert to grayscale, if necessary

img = imread('../data/cv_cover.jpg');
img_gray = img;
if size(size(img), 2) == 3
    img_gray = rgb2gray(img_gray);
end

count_of_matches = [];
indices = [];
%% Compute the features and descriptors

% This is common for all loops. So keep it outside
fast_features_img = detectFASTFeatures(img_gray);
[desc_img, locs_img] = computeBrief(img_gray, fast_features_img.Location);

%% Choose random indices to visualize
vis_indices = [0,1,20];

for i = 0:36
    %% Rotate image
    img_rotated = imrotate(img_gray, i * 10);

    %% Compute features and descriptors
    fast_features_img_rotated = detectFASTFeatures(img_rotated);
    [desc_img_rotated, locs_img_rotated] = computeBrief(img_rotated, fast_features_img_rotated.Location);
    
    %% Match features
    matched_features = matchFeatures(desc_img, desc_img_rotated, 'MatchThreshold', 10.0, 'MaxRatio', 0.7);
    matched_indices_img = matched_features(:,1);
    matched_indices_img_rotated = matched_features(:,2);
    matched_locs_img = locs_img(matched_indices_img, :);
    matched_locs_img_rotated = locs_img_rotated(matched_indices_img_rotated, :);
    %% Update histogram
    count_of_matches(end+1) = size(matched_locs_img, 1);
    indices(end+1) = i;
    
    if any(vis_indices(:) == i)
        figure;
        showMatchedFeatures(img, img_rotated, matched_locs_img, matched_locs_img_rotated, 'montage');
    end
end
indices(end+1) = 37;

%% Display histogram
figure;
histogram('BinEdges',indices,'BinCounts',count_of_matches)



%% SURF Section
count_of_matches = [];
indices = [];
%% Compute the features and descriptors

% This is common for all loops. So keep it outside
fast_features_img = detectSURFFeatures(img_gray);
[desc_img, locs_img] = extractFeatures(img_gray, fast_features_img.Location, 'Method', 'SURF');

vis_indices = [0,1,20];

for i = 0:36
    %% Rotate image
    img_rotated = imrotate(img_gray, i * 10);

    %% Compute features and descriptors
    fast_features_img_rotated = detectSURFFeatures(img_rotated);
    [desc_img_rotated, locs_img_rotated] = extractFeatures(img_rotated, fast_features_img_rotated.Location, 'Method', 'SURF');
    
    %% Match features
    matched_features = matchFeatures(desc_img, desc_img_rotated, 'MatchThreshold', 10.0, 'MaxRatio', 0.75);
    matched_indices_img = matched_features(:,1);
    matched_indices_img_rotated = matched_features(:,2);
    matched_locs_img = locs_img(matched_indices_img, :);
    matched_locs_img_rotated = locs_img_rotated(matched_indices_img_rotated, :);
    %% Update histogram
    count_of_matches(end+1) = size(matched_locs_img, 1);
    indices(end+1) = i;
    
    if any(vis_indices(:) == i)
        figure;
        showMatchedFeatures(img, img_rotated, matched_locs_img, matched_locs_img_rotated, 'montage');
    end
end
indices(end+1) = 37;

%% Display histogram
figure;
histogram('BinEdges',indices,'BinCounts',count_of_matches)