function [ Y ] = imgreduce( X, G, B )
% IMGREDUCE Reduces image size and grayscale resolution
% Y = IMGREDUCE(X, G, B) reduces the grayscale image X by
% downsampling the image by a factor G in each dimension and by
% reducing the grayscale resolution to B bits per pixel.
% X is an m x n matrix where m and n are the height and the width of
% the image, respectively, measured in pixels. The entries of X are
% values of type UINT8 (unsigned 8-bit integers) between 0 and 255,
% where 0 means black and 255 means white; values in between stand
% for intermediate shades of gray. G must be a positive integer, B
% must be an integer between 1 and 8.
% The output Y is a UINT8 matrix obtained by taking every G-th point
% of X (horizontally and vertically), starting with X(1,1), and scaling
% the values to lie in the interval [0, 2^B-1] such that 0 corresponds
% to black and 2^B-1 corresponds to white.

if (B < 1) || (B > 8)
    error('Invalid argument: B must be an integer in {1,2,...,8}');
end

% Downsampling by G in both dimensions
X_ds = X(1:G:end,1:G:end);

% Scaling
Y = bitshift(X_ds, B-8);

end

