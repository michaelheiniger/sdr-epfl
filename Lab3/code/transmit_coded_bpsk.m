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
% Corresponding polynomial {'1 + x^1', '1 + x^1 + x^2'}
trellis = poly2trellis(constraint_length, [5 7]);

% Convolutional encoding of S
S_coded = convenc(S, trellis);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulation, transmission over AWGN channel and demodulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BPSK = my_pskmap(2); % Binary-PSK

S_mod = my_modulator(S_coded, BPSK);
% Nicolae: checking the energy of Tx signal
Es_coded = var(S_mod);
% Nicolae: it is always good to check the energy of Tx and add the
% parameter 'measured'. Just to avoid surprises. In this case the energy is
% indeed 1.
S_mod_noisy = awgn(S_mod, Es_sigma2,'measured');

% Nicolae: you do not do demodulation here because otherwise you loose all
% the power of the Viterbi (ML) decoding. Demodulation implies taking
% decisions, and we do not want that.
S_demod = S_mod_noisy;
%S_demod = my_demodulator(S_mod_noisy, BPSK);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Viterbi decoding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tblen = 15;
opmode = 'trunc';
%dectype = 'soft';
%nsdec = 1;

% Nicolae: you had to use the 'unquant' option for decoding, which tells
% the decoder that you pass directly the values from the channel
S_EST = vitdec(S_demod, trellis, tblen, opmode, 'unquant');
%S_EST = vitdec(S_demod, trellis, tblen, opmode, dectype, nsdec);

% Bit Error Rate calculation
error_count = sum(S ~= S_EST);
BER = error_count/length(S);

end

