clear all; 

load('siren.mat');

% police siren frequency
f=1000;

% speed of sound
c=343; %m/s

% sampling frequency of the received signal
Fs=1e4;


% (a)
NFFT = 2^nextpow2(length(sr));
siren_fft = fft(sr, NFFT);
siren_fft_abs = abs(siren_fft);
siren_fft_abs = fftshift(siren_fft_abs);
f_axis = linspace(-Fs/2, Fs/2-Fs/NFFT, NFFT);
plot(f_axis, siren_fft_abs);

% (b)
% Since the recorded frequency is 3956 > 1000 Hz, it means that the police
% car is closing in the the chased car, hence the police car goes faster.

% (c)

