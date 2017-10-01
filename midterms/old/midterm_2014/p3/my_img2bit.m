% function [bits] = my_img2bit(img_name). 
% It converts an image to a sequence of bits.

function [bits] = my_img2bit(img_name)

img = imread(img_name);

img_column = img(:);
bits = de2bi(img_column, 16);
bits = transpose(bits);

bits = bits(:);

end