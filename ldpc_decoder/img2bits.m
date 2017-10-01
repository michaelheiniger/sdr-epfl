% IMG2BITS Converts an image to a sequence of bits
%    S = IMG2BITS(X, B) returns a row vector S that is obtained by
%    serializing the image matrix X column by column and then converting
%    each value to its binary representation. The conversion to bits is
%    'right-msb'. The number of bits per pixel is given by B; B must be
%    larger than or equal ceil(log2(M+1)), where M is the largest value
%    of X. 

% $Id: img2bits.m 1498 2012-11-28 18:23:18Z jimenez $

function s = img2bits(x,B)

% Input checking
if (length(size(x)) > 2)
    error('img2bits:InvalidInputs', 'Input image array must have at most 2 dimensions')
end

if (B<ceil(log2(double(1+max(max(x))))) )
    error('img2bits:InvalidInputs','Number of bits not large enough to represent all valuse')
end


BPP = max(ceil(log2(double(1+max(max(x))))),B); 
% Notice that although max is defined for variable of type uint8, log2 is 
% not, so we need to coherce a cast to double

num_pixels = numel(x); % equivalently, samples = prod(size(x));
s = zeros(1, BPP*num_pixels);

% Transpose the output of my_de2bi, so we effectively read it into s
% columnwise. s(:) allows us to assign to all the elements of s without
% changing its shape
s(:) = transpose(my_de2bi(x(:), 'right-msb', BPP));



