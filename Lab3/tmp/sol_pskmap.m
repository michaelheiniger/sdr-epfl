% MY_PSKMAP Create constellation for Phase Shift Keying modulation
% C = MY_PSKMAP(M) outputs a 1xM vector with the complex symbols
% of the PSK constellation of alphabet size M, where M is an integer power of 2

function c = my_pskmap(M)

% Verify that M is an integer power of two
if (log2(M) ~= fix(log2(M)))
    error('my_pskmap:invalidSize', 'M must be in the form of M = 2^K, where K is a positive integer.');
end

c = exp(1i*2*pi*(0:M-1)/M);
