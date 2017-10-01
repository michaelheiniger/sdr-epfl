clear all; 

load('siren');

% police siren frequency
f0=1000;

% speed of sound
c=343; %m/s

% sampling frequency of the received signal
fs=1e4;


%% (a)
NFFT = 2^nextpow2(length(sr));
freq = linspace(-fs/2,fs/2-fs/NFFT,NFFT);
siren_abs_fft = abs(fftshift(fft(sr, NFFT)));
plot(freq,siren_abs_fft);
xlabel('[Hz]');
ylabel('|Siren_f(f)|');

% Frequency of the siren is 1044 Hz

%% (b)
% The actual frequency of the siren is 1kHz = 1000Hz which is smaller than
% the perceived siren frequency (1044Hz). It means that the police car is
% closing in on the chased car. So the police car is faster.

% (c)
f = 1044; % [Hz]
v = c*(f/f0 - 1) % [m/s]





