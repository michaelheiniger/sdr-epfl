% MY_PSKMAP Creates constellation for Phase Shift Keying modulation
% C = MY_PSKMAP(M) outputs a 1xM vector with the complex symbols
% of the PSK constellation of alphabet size M, where M is an integer power of 2.
function [ c ] = my_pskmap( m )

if mod(log2(m),1) ~= 0
   error('M must be in the form M = 2^K, where K is a positive integer.');
end

c = exp(1i*2*pi*(0:m-1)/m);

end

