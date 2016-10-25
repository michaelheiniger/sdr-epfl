a = [ 0 0 0 0 0 0 0 1 2 3 0 0 0 0]
b = [ 1 2 3 ]

[c, lags] = xcorr(a,b);
[val, indx] = max(c)
lags(indx)