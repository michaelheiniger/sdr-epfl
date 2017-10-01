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

if mod(0.5*log2(M),1) ~= 0
   error('M must be the square of a power of 2.');
end


axis_1 = log2(M)-1:-2:-log2(M)+1;
axis_2 = -log2(M)+1:2:log2(M)-1;

[y, x] = ndgrid(axis_1, axis_2);

constellation = x + 1i*y;

% Normalize vector
constellation = constellation/norm(constellation);

constellation = transpose(constellation(:));

bits_grouped = reshape(transpose(bits), log2(M),length(bits)/log2(M));

dec = bi2de(transpose(bits_grouped(:,:)));
symbols = constellation(dec+1);




end