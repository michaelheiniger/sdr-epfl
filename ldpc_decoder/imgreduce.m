% IMGREDUCE Reduces image size and grayscale resolution
%    Y = IMGREDUCE(X, G, B) reduces the grayscale image X by
%    downsampling the image by a factor G and by reducing the grayscale
%    resolution to B bits per pixel. 
%    X is an m x n matrix where m and n are the height and the width of
%    the image, respectively, measured in pixels. The entries of X are
%    values of type UINT8 (unsigned 8-bit integers) between 0 and 255,
%    where 0 means black and 255 means white; values in between stand
%    for intermediate shades of gray. G must be a positive integer, B
%    must be an integer between 1 and 8.
%    The output Y is a UINT8 matrix obtained by taking every G-th point of X (horizontally and
%    vertically), starting with X(1,1), and scaling the values to lie in
%    the interval [0, 2^B-1] such that 0 corresponds to black and 2^B-1
%    corresponds to white. 

% $Id: imgreduce.m 1312 2011-10-05 16:18:04Z tarniceriu $

function y = imgreduce(x, g, b)

% Input checking
if (b < 1 || b > 8)
    error('imgreduce:InvalidInputs', 'Output bit depth must be between 1 and 8 bpp')
end


% First check that x can be cast as uint8
x = uint8(x);

% Downsample
x_down = x(1:g:end, 1:g:end);

% Bitshift
y = bitshift(x_down, b-8); 


    
    
