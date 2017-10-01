clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tx side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters:
N_bits = 10; % Number of bits to transmit
m = 4;
map = my_qammap(m); % Modulator

EsNo = 1; % dB

% Generate random bits to send
bits_tx = randi(2,1,N_bits)-1;

% Pad with 0s to match the bits/symbol ratio
num_zeros_to_add = m - mod(N_bits, log2(m));
bits_tx = [bits_tx, zeros(1,num_zeros_to_add)]

% Modulate the bits
symbols_tx = zeros(1,length(bits_tx)/log2(m));
i = 1;
for k = 1:log2(m):length(bits_tx)
    current_bits = bits_tx(k:k+log2(m)-1);
    current_bits_str = mat2str(current_bits);
    dec = bin2dec(current_bits_str(2:end-1));
    symbols_tx(i) = my_modulator(dec, map);
    i = i+1;
end

% Pulse design:
fd = 1;        % symbol rate 
usf = 5;       % up-sampling factor - should be at least 2 to work
fs = usf * fd; % sampling frequency
	
beta = 0.22;   % roll-off factor
delay = 8;     % measured in number symbol periods (determines the order of the filter)
               % we are truncating the impulse response to keep 'delay' symbol periods on each side of the central value

h = rcosdesign(beta, 2*delay, fs, 'sqrt'); % here the filter is already normalized to norm 1

% Symbols to samples
signal_samples = sol_symbols2samples(symbols_tx, h, usf);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AWGN Channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add white Gaussian noise with SNR EsNo
r = awgn(signal_samples, EsNo, 'measured');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rx side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute the sufficient statistics using matched-filter method
sufficient_stats = my_sufficientstatistics(r, h, usf);

% Convert into symbols using minimum distance (ML detector in AWGN channel)
symbols_rx = my_demodulator(sufficient_stats, map);

% Convert symbols back into bits
bits_rx = ((dec2bin(symbols_rx)))


