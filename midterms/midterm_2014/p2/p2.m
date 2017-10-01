clear all;
clc;
fs=1e6;
c=300000000; % m/sec

load 'probe'
load 'reply'

% Find the number tau of samples elapsed between Tx and Rx of probe
[R, ~] = xcorr(reply, probe); % Cross-correlation
R = R(length(reply):end); % Remove ramp-up
[~, tau] = max(abs(R)); % Find tau

% Time of travel
tt = tau/fs;

% One-way time of travel
owtt = tt/2;

% Distance from radar to obstacle
display('Distance in m');
distance = c*owtt; % 127650 m
display('Distance in km');
distance/1000; % 127.65 km
