clear all
clc

Fs=1e6;
c=300000; % Km/sec

load 'probe'
load 'reply'

[corr, ~] = xcorr(reply, probe);

corr = corr(length(reply):end);

% Delay is in number of samples
[~, delay] = max(corr);

%delay
delay/Fs*c/2

