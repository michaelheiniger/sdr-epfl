function [ Y ] = my_modulator( X, MAP )
% MY_MODULATOR Maps a vector of M-ary integers to constellation points
% Y = MY_MODULATOR(X, MAP) outputs a vector of (possibly complex)
% symbols from the constellation specified as second parameter,
% corresponding to the integer valued symbols of X.
% Input X can be a row or column vector, and output Y has the same
% dimensions as X.
% If the length of MAP is M, then the message symbols of X
% must be integers between 0 and M-1.

check = sum(arrayfun(@(x) x < 0 || x > length(MAP)-1, X));

if check > 0
     error('Symbols of X must be in [0;M-1]');
end

Y = arrayfun(@(x) MAP(x), X+1);

end

