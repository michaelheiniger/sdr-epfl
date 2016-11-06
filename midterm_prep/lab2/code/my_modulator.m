
% MY_MODULATOR Maps a vector of M-ary integers to constellation points
% Y = MY_MODULATOR(X, MAP) outputs a vector of (possibly complex)
% symbols from the constellation specified as second parameter,
% corresponding to the integer valued symbols of X.
% Input X can be a row or column vector, and output Y has the same
% dimensions as X.
% If the length of MAP is M, then the message symbols of X
% must be integers between 0 and M-1.
function [y] = my_modulator(x, map)

m = length(map);
check = sum(arrayfun(@(a)(a < 0 || a >= m), x));

if check ~= 0
   error('Elements of x must be in {0,1,...,M-1}.'); 
end

% Check the format of x
[~, cols] = size(x);

if cols == 1
   % x is a row vector
   map = transpose(map);
end

y = map(x+1);

end

