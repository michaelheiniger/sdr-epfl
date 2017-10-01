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

% 


%determine the number of used carriers
num_useful_carriers = num_carriers - 2 * num_zeros;
if (numel(preamble_symbols) ~= num_useful_carriers)
    error('ofdm_tx_frame:dimensionsMismatch', ...
          'The preamble must contain exactly NUM_CARRIERS - 2*NUM_ZEROS symbols (i.e, the number of useful carriers');
end

num_data_symbols = numel(data_symbols);
num_ofdm_symbols = ceil(num_data_symbols/ num_useful_carriers);
num_symbols_padding =  num_ofdm_symbols * num_useful_carriers- num_data_symbols; % number of zero symbols to add to have an exact number of OFDM symbols
data_symbols = [data_symbols(:); zeros(num_symbols_padding, 1)];

num_ofdm_symbols = num_ofdm_symbols + 1; % we use one OFDM symbol for the preamble (to aid channel estimation)

% build matrix: the first column is for the preamble, and the following for the data
B = zeros(num_useful_carriers, num_ofdm_symbols);
B(:,1) = preamble_symbols(:);
B(:,2:end) = reshape(data_symbols(:), num_useful_carriers, []);

% add unused carriers at both ends of the spectrum
A = [zeros(num_zeros, num_ofdm_symbols); B; zeros(num_zeros, num_ofdm_symbols)]; % A is size num_carriers x num_ofdm_symbols

% Do the IFFT (MATLAB IFFT applied on a matrix returns a matrix with the IFFT of every column)
a0 = ifft(A, num_carriers);

% Before sending through the channel we have to add the cyclic prefix
a = [a0(num_carriers-prefix_length+1:num_carriers,:); a0];

% serialize, so that the output is a column vector
tx_signal = a(:);




