function [ X ] = bits2img( S, B, M, N )
% BITS2IMG Converts a vector of bits to an image
%X = BITS2IMG(S, B, M, N) returns an M x N matrix X whose entries
% are of type UINT8 that is obtained by reconstructing the image from
% the bit sequence S. B is the number of bits per pixel, and M and N
% are the height and width of the image, respectively. The number of
% elements in S must be equal to M*N*B.

if length(S) ~= B*M*N
   error('Invalid argument: B*M*N must be equal to the length of S.'); 
end

% Form a matrix with each row being a pixel to prepare for conversion
% The parameter B must be the same of the one used with img2bits
pixels_rows_bits = transpose(reshape(S, B, M*N));

% Actual conversion from binary to decimal
pixels_rows = bi2de(pixels_rows_bits, 'left-msb');

% Reshape to form the image
image = reshape(pixels_rows, M, N);

% Cast to go back to original format unint8
X = uint8(image);

end

