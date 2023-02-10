% aspect ratio of book image (from image dimension) =  350 / 440  = 0.8
% aspect ratio of film frame (from frame dimension) = 640 / 360  = 1.77
% reasonable crop to mimic the aspect ratio of the cv book is 
% 240 / 300 = 0.8 => so mid width is at 640/2=320. Crop : 320-120 to 320+120
% mid height is at 360/2=180. Crop: 180-150 to 180+150

cv_img = imread('../data/cv_cover.jpg');
cv_book_video = loadVid('../data/book.mov');   
kung_fu_panda_video = loadVid('../data/ar_source.mov');   

frames_in_cv_book_video = size(cv_book_video, 2);
frames_in_kung_fu_panda_video = size(kung_fu_panda_video, 2);

final_render_file = VideoWriter('../results/ar.avi');
open(final_render_file);


for i = 1:frames_in_kung_fu_panda_video
    book_frame = cv_book_video(i).cdata;
    [locs1, locs2] = matchPics(cv_img, book_frame);
    [bestH2to1, inliers] = computeH_ransac(locs1, locs2);
    film_frame = kung_fu_panda_video(i).cdata;
    film_frame = film_frame(30:230, 200:440, :);
    film_frame = imresize(film_frame, [size(cv_img, 1), size(cv_img, 2)]);
    aug_frame = compositeH(bestH2to1, film_frame, book_frame);
    writeVideo(final_render_file, aug_frame);
end

close(final_render_file);