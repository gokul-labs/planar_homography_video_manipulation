function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points

% P' = H.P ==> x1 = H.x2 ==> H ?

n = size(x1, 1);
H2to1 = zeros(1,9);
A = zeros(2 * n, 9);

% from lecture slide 47,
count = 1;
for i = 1:n
    x = x2(i, 1);
    y = x2(i, 2);
    x_prime = x1(i, 1);
    y_prime = x1(i, 2);

    A(count,:) = [-x, -y, -1, 0, 0, 0, x*x_prime, y*x_prime, x_prime];
    count = count + 1 ;
    A(count,:) = [0, 0, 0, -x, -y, -1, x*y_prime, y*y_prime, y_prime];
    count = count + 1 ;
end

% A.h = 0
[U, sigma, V] = svd(A);
H2to1 = V(:, 9);
H2to1 = reshape(H2to1, [3,3]);
H2to1 = H2to1';
end
