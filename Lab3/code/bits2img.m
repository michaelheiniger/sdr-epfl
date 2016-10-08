function [ X ] = bits2img( S, B, M, N )
% BITS2IMG Converts a vector of bits to an image
%X = BITS2IMG(S, B, M, N) returns an M x N matrix X whose entries
% are of type UINT8 that is obtained by reconstructing the image from
% the bit sequence S. B is the number of bits per pixel, and M and N
% are the height and width of the image, respectively. The number of
% elements in S must be equal to M*N*B.

tmp = transpose(reshape(S, B, M*N));

tmp_bits = bi2de(tmp, 'left-msb');

X = uint8(reshape(tmp_bits, M, N));

end

