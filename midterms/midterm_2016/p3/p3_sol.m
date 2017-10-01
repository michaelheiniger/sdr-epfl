
clear all; close all;

load('qamData.mat');
 
Ts=1e-6;
fs = 1/Ts;
Tp=1/200;
N=Tp/Ts % length to get the correct resolution

% verify that the data it sufficiently long
if N > length(qamData) 
    error('Not Enough Data')
end

% check that N is even; if not, make is shorter by 1
if mod(N,2) == 1
    N=N-1
end

q=qamData(1:N);

% check what we have
figure(1);
plot(qamData,'*'); grid on;
xlabel('Real'); ylabel('Imag'); title('Received constellation');
 
% raise to 4th power to remove the 4-QAM symbols
q4 = q.^4;
 
fq4 = fft(q4); 

% check what we have 
figure(2); 
freq = -fs/2:fs/N:fs/2-fs/N;
stem(freq, fftshift(abs(fq4)),'*'); 
grid on;
xlabel('f [Hz]'); ylabel('|FFT|^2'); 
title('FFT showing the Doppler');

[val, pos] = max(abs(fq4)); % get the peak which corresponds to the Doppler

% due to fftshift: positive frequencies are in the 1st half, negative ones are in the 2nd half
if pos <= N/2
    Doppler = (pos-1)/Tp/4
else
    Doppler = (pos-1-N)/Tp/4
end

% correct for Doppler
t = (0:1:length(qamData)-1)*Ts;
qCorr = qamData.*exp(-2j*pi*Doppler*t);

% check what we have 
figure(3);
plot(qCorr,'*'); grid on;
xlabel('Real'); ylabel('Imag'); title('Doppler corrected constellation');