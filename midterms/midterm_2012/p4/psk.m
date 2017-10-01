% Simulate binary uncoded PSK transmitted over the AWGN channel
% Specific instructions:
%
% Set NrBits to E5;
% Set Es_sigma2 to 3 dB

% Produces a binary random sequence of length NrBits taking values in {0,1}

% Map the bit sequence into a symbol sequence where 0 --> 1 and 1 --> -1

% Create the output of the AWGN channel that has the symbol sequence as input
% The energy per symbol over the noise variance shall be Es_sigma2 in dB

% Determine the bit sequence estimate (maximum likelihood decoding)

% Compute and print the error probability

clear;
clc;

% Parameters
NrBits = 1e5;
Es_sigma2 = 3; % dB (SNR)

% Generate binary random sequence
bits = randi(2,1,NrBits)-1;

% Map bits to symbols
symbols = -2*bits+1;

% Simulate AWGN channel
rx_signal = awgn(symbols, Es_sigma2, 'measured');

% Maximum Likelihood Decoding
bits_rx = rx_signal;
bits_rx(bits_rx < 0) = 1;
bits_rx(bits_rx > 0) = 0;

BER = sum(bits ~= bits_rx)/length(bits)




