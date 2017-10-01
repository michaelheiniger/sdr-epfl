clear;
clc;

fs = 1000; % [Hz]
T = 10; % [s]
length_s = fs*T; % [#samples]

t = linspace(0,(length_s-1)/fs, length_s);

f1 = 100; % [Hz]
f2 = 300; % [Hz]
s = sin(2*pi*f1*t)+sin(2*pi*f2*t);
length(s)
% Frequency axis
NFFT = 1024; %2^nextpow2(length_s);
freq = linspace(-fs/2, fs/2-fs/NFFT, NFFT);
length(freq)

% FFT and abs
s_fft = fft(s, NFFT);
s_fft_shift = fftshift(s_fft);
s_fft_abs = abs(s_fft_shift);

plot(freq, s_fft_abs);
xlabel('[Hz]');
ylabel('|s_f(f)|');

