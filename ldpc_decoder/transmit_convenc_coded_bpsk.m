% TRANSMIT_CODED_BPSK Simulate convolutionally encoded BPSK transmission
%    across the AWGN channel
%
%    [S_EST, BER] = TRANSMIT_CODED_BPSK(S, Es_sigma2) simulates the
%    transmission of the bit sequence S across an additive white
%    Gaussian noise channel using convolutional coding and BPSK modulation.
%    The convolutional code used has rate 1/2 and octal generators [5 7]
%    A Viterbi decoder with soft decisions is used at the receiver.
%    S is a vector (row or column) with the bits to be transmitted.
%    Es_sigma2 is the the ratio, expressed in dB, of the energy per
%    symbol to noise variance at the output of the matched filter of
%    the receiver (sigma2 = N0/2).
%
%    The function has two return values: S_EST is a vector
%    (same dimensions as input S) containing the bit sequence
%    estimated by the receiver; BER is the bit error rate, i.e, 
%    the fraction of transmitted bits that were incorrectly decoded.

function [s_est, BER] = transmit_coded_bpsk(s, Es_sigma2)

% Describe our convolutional code
generator = [5 7];
constraint_length = 3; % = ceil(log2(max(generator)))
trellis = poly2trellis(constraint_length, generator);
% rate = 1/length(generator);

% for convolutional encoding we use the convenc function in Matlab Communication Toolbox
s = s(:); % make sure we work with a column vector
coded_bits = convenc([s; zeros(constraint_length-1, 1)], trellis); 

% we add enough zeros at the end of information bit sequence s to make sure that we end in the all-zero state
% (the 'term' option we will use in the decoder assumes that the encoder starts and ends in the all-zero state)

% If one uses 'trunc' option for the vitdec, no need for the extra zeros at
% the end
% coded_bits = convenc(s, trellis); 

% modulate coded bits in BPSK
tx_sym = 1-2*coded_bits; % mapping: bit 1 -> -1, bit 0 -> +1
    % This is the mapping assumed by the vitdec function;, the opposite one (bit 1-> +1, bit 0->-1) 
    % will not work with Matlab's implementation of the soft-decision Viterbi decoder

% Simulate the symbol-level, discrete equivalent channel, AWGN
rx_sym = awgn(tx_sym, Es_sigma2, 'measured');

    % Alternative if Matlab Comm. Toolbox were not available:
    % noise = sqrt(10^(-Es_sigma2/10)) * randn(size(tx_sym));
    % rx_sym = tx_sym + noise;

% We directly pass the unquantised channel outputs to the Viterbi decoder
trace_back_length = 15;
s_est = vitdec(rx_sym, trellis, trace_back_length, 'term', 'unquant'); % to use unquantised soft decisions
% or if we use the trunc option
% s_est = vitdec(rx_sym, trellis, trace_back_length, 'trunc', 'unquant');

% Trim the termination bits before computing the BER
s_est = s_est(1:length(s));

% Calculate the coded BER
BER = sum(s ~= s_est)/numel(s);
