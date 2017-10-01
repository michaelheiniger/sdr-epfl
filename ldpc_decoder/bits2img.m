% BITS2IMG Converts a vector of bits to an image
%    X = BITS2IMG(S, B, M, N) returns an M x N matrix X whose entries
%    are of type UINT8 that is obtained by reconstructing the image from
%    the bit sequence S. B is the number of bits per pixel, and M and N
%    are the height and width of the image, respectively. The number of
%    elements in S must be equal to M*N*B. 

% $Id: bits2img.m 1498 2012-11-28 18:23:18Z jimenez $

function x = bits2img(s, b, m, n)

% Input checking
if (numel(m)+numel(n)+numel(b) ~= 3)
    error('bits2img:InvalidInputs1', 'M, N and B must all be scalar values')
end
if (length(s) ~= m*n*b)
    error('bit2img:InvalidInputs2', 'Input bit array s must be of length M*N*B')
end

% Arrange vector s in a matrix with m*n rows and b columns, convert to
% decimal and cast as uint8
aux = transpose(reshape(s, b, m*n));
x = uint8(reshape(my_bi2de(aux), m, n));



