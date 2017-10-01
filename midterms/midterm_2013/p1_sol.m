% define the parameters
f1=100; f2=300;
Fs=1000;
NFFT=1024;
T=10; %seconds
t=0:1/Fs:T; % time vector
% length(t)
vf=-Fs/2:Fs/NFFT:Fs/2-Fs/NFFT; %frequency vector

% length(vf)
s=sin(2*pi*f1*t)+sin(2*pi*f2*t);
length(s)
%plot the frequency spectrum
figure, plot(vf,abs(fftshift(fft(s,NFFT)))), xlabel('f[Hz]'), ylabel('|s_F(f)|')