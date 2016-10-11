function [ S ] = img2bits( X, B )
% IMG2BITS Converts an image to a sequence of bits
% S = IMG2BITS(X, B) returns a row vector S that is obtained by
% serializing the image matrix X column by column and then converting
% each value to its binary representation. The conversion to bits is
% ’left-msb’. The number of bits per pixel is given by B; B must be
% larger than or equal ceil(log2(M+1)), where M is the largest value
% of X.

M = double(max(max(X))); % Conversion from uint8 to satisfy log2

if B < ceil(log2(M+1))
   error('Invalid argument: B must be larger of equal than ceil(log2(M+1)).'); 
end

% Convert pixel values to binary. 
% Note: pixels are in unint8, so there will be at most (due to B) 8 bits 
% per pixels in binary.
X_bin = de2bi(X, B, 'left-msb');

% Transform matrix into a row-vector
S = reshape(transpose(X_bin),1, size(X_bin,1)*size(X_bin,2));

end

