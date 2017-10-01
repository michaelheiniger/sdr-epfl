

clc;
clear;

% Load noisy data
load('r.mat');

% Load noise-free preable
load('p.mat');
preamble = p;

% Load sent data
load('d.mat');

% Find the first full preamble
length_preamble = length(preamble);
length_infosymbols = 1e4;
length_frame = length_preamble + length_infosymbols;

% Number of complete frame (preamble+info symbols)
complete_frame = floor(length(r)/length_frame)-1;

mask = [ preamble, zeros(1, length_infosymbols)];
repmask = repmat(mask, 1, complete_frame);

[R, ~] = xcorr(r, mask);
R = R(length(r):end);
[~, tau] = max(abs(R))

first_preamble = r(tau:tau+length_preamble-1);
first_symbols = r(tau+length_preamble:tau+length_frame-1);

plot(first_symbols,'*')

y = first_symbols(:);
map = [ -1+1i, -1-1i, 1+1i, 1-1i ];
repy = repmat(y, 1, length(map));
repmap = repmat(map, length(y), 1);

distances = abs(repy-repmap);

[~,indices] = min(distances, [], 2);

symbols_est = map(indices);

ser = sum(symbols_est ~= d)/length(symbols_est)










