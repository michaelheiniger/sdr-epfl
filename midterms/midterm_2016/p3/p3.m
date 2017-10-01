clear;
clc;

load('qamData.mat');


Ts = 1/1e6;
fs = 1/Ts;

% Eliminate phase change
qamData = qamData.^4;

% 
resolution = 50; % Hz
NFFT = fs/resolution;
qamData_fft = fftshift(fft(qamData, NFFT));

freq = linspace(-fs/2,fs/2-fs/NFFT,NFFT);
plot(freq, qamData_fft);


