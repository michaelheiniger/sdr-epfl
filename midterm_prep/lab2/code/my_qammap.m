% MY_QAMMAP Creates constellation for square QAM modulations
% C = MY_QAMMAP(M) outputs a 1 x M vector with the
% constellation for the quadrature amplitude modulation of
% alphabet size M, where M is the square of an integer power
% of 2 (e.g. 4, 16, 64, ...).
% The signal constellation is a square constellation.
function [ c ] = my_qammap(m)

if mod(0.5*log2(m),1) ~= 0
   error('M must be in the form M = 2^(2K), where K is a positive integer.');
end

real_axis = sqrt(m)-1:-2:-sqrt(m)+1;
img_axis = -sqrt(m)+1:2:sqrt(m)-1;

[y,x] = ndgrid(real_axis, img_axis);

c = reshape(x + 1i*y, 1, m);
end

