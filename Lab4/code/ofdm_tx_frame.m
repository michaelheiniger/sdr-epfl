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

[~, ds_cols] = size(data_symbols);
if ds_cols ~= 1
   data_symbols = transpose(data_symbols); % Want a column-vector
end

[~, ps_cols] = size(preamble_symbols);
if ps_cols ~= 1
    preamble_symbols = transpose(preamble_symbols); % Want a column-vector
end

ofdm_useful_length = num_carriers - 2*num_zeros;

% Add zeros at the end of the data symbols to make it an integer multiple
% of the useful capacity of an ofdm symbol
num_zeros_to_pad = ceil(length(data_symbols) / ofdm_useful_length)*ofdm_useful_length - length(data_symbols);
data_symbols_padded = [data_symbols; zeros(num_zeros_to_pad, 1)];

% reshape the data symbols into a matrix
data_symbols_matrix_width = length(data_symbols_padded)/ofdm_useful_length;
data_symbols_matrix = reshape(data_symbols_padded, ofdm_useful_length, data_symbols_matrix_width);

% Add preamble to data symbols matrix
data_symbols_preamble_matrix = [preamble_symbols, data_symbols_matrix]; 

% Add lines of 0 on top and bottom of the data sybol matrix for the
% non-used subcarriers. Note: The +1 is here to take into account the
% preamble symbol
ofdm_frame = [zeros(num_zeros,data_symbols_matrix_width+1); data_symbols_preamble_matrix; zeros(num_zeros,data_symbols_matrix_width+1)];

% Apply IFFT on ofdm frame
ofdm_frame_ifft = ifft(ofdm_frame);

% Get the part of the matrix to be used as prefix
cyclic_prefix = ofdm_frame_ifft(end-prefix_length+1:end,:);

% Add cyclic prefix
ofdm_frame_ifft_prefix = [cyclic_prefix ;ofdm_frame_ifft];

total_number_symbols_to_transmit = size(ofdm_frame_ifft_prefix,1)*size(ofdm_frame_ifft_prefix,2);

% Reshape to output a column-vector
tx_signal = reshape(ofdm_frame_ifft_prefix, total_number_symbols_to_transmit,1);

end