clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tx/Rx common parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Size of constellation
M = 4;
MAP = my_qammap(4);

% Basic Pulse (Root-Raised Cosine Function)
BETA = 0.22; % Roll-off factor

T = 1; % [seconds], duration of one symbol
fs = 4000; % [Hz], = 4kHz donc on 
SPS = T*fs;
SPAN = 6; % Number of symbols 
SPS = 4; % Number of samples per symbol
% length(H) = SPAN * SPS + 1 %(why ?)
H = rcosdesign(BETA, SPAN, SPS); % Already normalized

% Upsampling factor
USF = 10; %??? USF = Fs/Fd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tx side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Generate a random message
N = 20; %10e6; % Number of bits to transmit. Must be a multiple of log2(M)
if mod(N/log2(M),1) ~= 0
   error('N must be a multiple of log2(M).'); 
end
%TEMP Generate random decimal numbers in [0;M-1]
X_dec = randi(M, 1, N/log2(M))-1; % Message in decimal in [0; M-1]
X_bits = dec2bin(X_dec); % Message in bits
% END TEMP

X = bin2dec(X_bits);

% "Modulate"
Y = my_modulator(X, MAP); % Message modulated


% Interpolation with pulse
Z = my_symbols2samples(Y, H, USF);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation of channel (AWGN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Energy-per-symbol to noise variance ratio: E_s/sigma²
snr = 10*log10(10); % dB  

% Add Gaussian Noise
% R = awgn(Z, snr);
R = Z;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rx side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y_rec = my_sufficientstatistics(R, H, USF);

sPlotFig = scatterplot(Y_rec,1,0,'g.');
hold on;
scatterplot(my_qammap(4),1,0,'k*',sPlotFig);
% % % 
% X_rec_dec = my_demodulator(X, MAP);
% 
% X_rec_bits = dec2bin(X_rec_dec);

%?????????





