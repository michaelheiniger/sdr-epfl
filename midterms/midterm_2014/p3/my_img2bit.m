% function [bits] = my_img2bit(img_name). 
% It converts an image to a sequence of bits.

function [bits] = my_img2bit(img_name)



img = imread(img_name);

% bits per pixel
BPP = max(ceil(log2(double(1+max(max(img))))));

img2bits = transpose(de2bi(img, BPP));

bits = img2bits(:);


end