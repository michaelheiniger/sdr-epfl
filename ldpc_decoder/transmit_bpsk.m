% TRANSMIT_BPSK Simulate BPSK transmission across AWGN channel
%    [S_EST, BER] = TRANSMIT_BPSK(S, Es_sigma2) simulates the
%    transmission of the bit sequence S across an additive white
%    Gaussian noise channel using BPSK modulation.
%    S is a vector (row or column) with the bits to be transmitted.
%    Es_sigma2 is the the ratio, expressed in dB, of the energy per 
%    symbol to noise variance at the output of the matched filter 
%    of the receiver (sigma2 = N0/2).
%
%    The function has two return values: S_EST is a vector
%    (same dimensions as input S) containing the bit sequence
%    estimated by the receiver; BER is the bit error rate, i.e, 
%    the fraction of transmitted bits that were received incorrectly. 

function [s_est, BER] = transmit_bpsk(s, Es_sigma2)

% modulate bits in BPSK
tx_sym = 1-2*s; % mapping: bit 0 -> +1, bit 1 -> -1
    
% Simulate the symbol-level, discrete equivalent channel, AWGN
rx_sym = awgn(tx_sym, Es_sigma2, 'measured'); % if we do not want to bother computing the signal power
    
    % Alternative if Matlab Comm. Toolbox were not available:
    % noise = sqrt(10^(-Es_sigma2/10)) * randn(size(tx_sym));
    % rx_sym = tx_sym + noise;
    
% Demodulate
s_est = (rx_sym < 0); % decision threshold is 0

% Compute bit error rate
BER = sum(s ~= s_est)/length(s);
