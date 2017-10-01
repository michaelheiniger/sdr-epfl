clc;
clear;

y = [1 1i 0.9 -0.9+0.1*1i 1+0.9*1i];

y_is_row = size(y,1) == 1;

% Make y a column vector
y = y(:);

% Row-vector
constellation = [-1i, 1, 1i, -1];

% Form matrices to compute distanc matrix
repy = repmat(y, 1, length(constellation));
repconst = repmat(constellation, length(y), 1);

% Compute distances matrix
distances = abs(repy-repconst);

% Get indices of min distances
[~, indices] = min(distances, [], 2);

z = indices-1;

if y_is_row
    z = transpose(z);
end

z


