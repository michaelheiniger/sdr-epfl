% function [symbols, constellation] = my_mapper(bits, M).
% It maps a sequence of bits into a sequence of symbols taking values in a M -QAM constellation. 
% It returns the symbol sequence and the constellation. 
% Specifically, it shall carry out the following tasks:
% 
% (i) Check if the input M is the square of an integer power of 2 (e.g. 4, 16, 64, ...).
% Print an error message and stop the program if it is not the case.
% (ii) Generate a unit-norm constellation vector named constellation of size 1xM .
% (iii) Map the bit-vector into a symbol vector.

function [symbols, constellation] = my_mapper(bits, M)

% i)
if mod(log2(sqrt(M)),1) ~= 0
   error('M must be the square of an integer power of 2 (e.g 4, 16, 64, ...).');
end

% ii)
s_per_area = M/4;
s_per_line_area = sqrt(s_per_area);
s_max = 1+(s_per_line_area-1)*2;
real = -s_max:2:s_max; 
im = s_max:-2:-s_max;

[x,y] = meshgrid(real, im);
qam = x + 1i*y;
% Make it unit-norm
qam = qam/norm(qam);

constellation = transpose(qam(:));

% iii)

bits = bits(:);
bits_grouped = reshape(bits, log2(M),ceil(length(bits)/log2(M)));
bits_grouped = transpose(bits_grouped);
dec = bi2de(bits_grouped); % right-msb !!!

symbols = constellation(dec+1);






end