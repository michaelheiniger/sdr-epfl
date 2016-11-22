function [ S_EST, BER ] = transmit_bpsk( S, Es_sigma2 )
% TRANSMIT_BPSK Simulate BPSK transmission across the AWGN channel
% [S_EST, BER] = TRANSMIT_BPSK(S, Es_sigma2) simulates the
% transmission of the bit sequence S over an additive white
% Gaussian noise channel using BPSK modulation.
% S is a row or column vector with the bits to be transmitted.
% Es_sigma2 is the ratio, expressed in dB, of the energy per
% symbol to noise variance at the output of the matched filter
% of the receiver.
% The function has two return values: S_EST is a vector
% (same dimensions as input S) containing the bit sequence
% estimated by the receiver; BER is the bit error rate, i.e,
% the fraction of bits that were received incorrectly.

BPSK = my_pskmap(2); % Binary-PSK

% Modulation
S_mod = my_modulator(S, BPSK);

% Nicolae: checking the energy of the Tx signal
Es_uncoded = var(S_mod);

% AWGN Channel simulation
% Nicolae: you need to use the parameter 'measured', since you do not know
% if the energy of your signal is 1
S_mod_noisy = awgn(S_mod, Es_sigma2,'measured');
%S_mod_noisy = awgn(S_mod, Es_sigma2);

% Demodulation
S_EST = my_demodulator(S_mod_noisy, BPSK);

% Bit Error Rate calculation
error_count = sum(S ~= S_EST);
BER = error_count/length(S);

end

