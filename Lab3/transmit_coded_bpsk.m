function [S_EST, BER] = transmit_coded_bpsk( S, Es_sigma2 )
% TRANSMIT_CODED_BPSK Simulate convolutionally encoded BPSK
% transmission across the AWGN channel with Viterbi decoding
% [S_EST, BER] = TRANSMIT_CODED_BPSK(S, Es_sigma2)
% simulates the transmission of the bit sequence S
% across the additive white Gaussian noise channel
% using convolutional coding and BPSK modulation.
% The convolutional code used has rate 1/2 and octal generators [5 7].
% A Viterbi decoder with soft decisions is used at the receiver.
% S is a row or column vector with the bits to be transmitted.
% Es_sigma2 is the ratio, expressed in dB, of the energy per
% symbol to noise variance at the output of the matched
% filter of the receiver.
% 
% The function has two return values:
% S_EST is a vector containing the bit sequence estimated
% by the receiver (same dimensions as input S).
% BER is the bit error rate, i.e., the fraction of the
% transmitted bits that were incorrectly decoded.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convolutional encoding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constraint_length = 3;
%{'1 + x^1', '1 + x^1 + x^2'}
trellis = poly2trellis(constraint_length, [5 7]);

% Coding of S using previously specified convolutional code
S_coded = convenc(S, trellis);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulation, transmission over AWGN channel and demodulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BPSK = my_pskmap(2);

S_mod = my_modulator(S_coded, BPSK);
S_mod_noisy = awgn(S_mod, Es_sigma2);

S_demod = my_demodulator(S_mod_noisy, BPSK);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Viterbi decoding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tblen = 15;
opmode = 'trunc';
dectype = 'soft';
nsdec = 1;
S_EST = vitdec(S_demod, trellis, tblen, opmode, dectype, nsdec);

error_count = sum(S ~= S_EST);
BER = error_count/length(S);

end

