function [ S ] = img2bits( X, B )
% IMG2BITS Converts an image to a sequence of bits
% S = IMG2BITS(X, B) returns a row vector S that is obtained by
% serializing the image matrix X column by column and then converting
% each value to its binary representation. The conversion to bits is
% ’right-msb’. The number of bits per pixel is given by B; B must be
% larger than or equal ceil(log2(M+1)), where M is the largest value
% of X.

X_bin = de2bi(X, B, 'left-msb');

S = reshape(transpose(X_bin),1, size(X_bin,1)*size(X_bin,2));

end

