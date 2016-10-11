function [tx_signal] = ofdm_tx_frame(num_carriers, num_zeros, prefix_length, preamble_symbols, data_symbols)

% OFDM_TX_FRAME Generates an OFDM frame
% TX_SIGNAL = OFDM_TX_FRAME(NUM_CARRIERS, NUM_ZEROS, PREFIX_LENGTH, PREAMBLE_SYMBOLS, DATA_SYMBOLS)
%   NUM_CARRIERS: number of sub-carriers (power of 2) 
%   NUM_ZEROS: number of zero carriers at either end of the spectrum 
% 	PREFIX_LENGTH: length of cyclic prefix (in number of samples) 
%   PREAMBLE_SYMBOLS: vector of symbols for the preamble, used to aid 
%       channel estimation (length equal to NUM_CARRIERS - 2*NUM_ZEROS, i.e,
%       the number of useful carriers)
%   DATA_SYMBOLS: vector of symbols to transmit (if the number of data
%       symbols is not a multiple of the number of useful carriers it will
%       be padded with zeros)
%
% TX_SIGNAL: The generated OFDM signal, corresponding to one OFDM frame with
% the preamble transmitted during the first OFDM symbol and the data
% transmitted in the subsequent OFDM symbols.


