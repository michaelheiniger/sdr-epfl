% OFDM receiver

clear; close all; clc;

% System parameters
num_carriers = 256;    % total number of carriers
num_zeros = 5;         % number of unsused carriers (at each end of the frequency spectrum)
prefix_length = 25;    % length of the cyclic prefix
num_ofdm_symbols = 2;  % number of OFDM symbols per frame (1 will be used to transmit the preamble and the rest for data)


%load the received time domain data and the preamble
load ofdm_ex


% Implement the OFDM receiver and perform channel equalization. 
% The channel coefficients in the frequency domain should be estimated using the received data and the preamble
% You should use the simplest method seen in class, there is no need to estimate correlation matrices

% Reshape into matrix form
signal_matrix = reshape(rx_signal, num_carriers+prefix_length, []);

% Remove cyclic prefix
signal_matrix = signal_matrix(prefix_length+1:end,:);

%  FFT of the matrix
signal_matrix = fft(signal_matrix, num_carriers);

% Remove zero-carriers
signal_matrix = signal_matrix(num_zeros+1:end-num_zeros,:);

% Extract preamble
preamble_rx = signal_matrix(:,1);

% Channel Equalization
lambda = preamble_rx ./ preamble;
signal_matrix = signal_matrix ./ repmat(lambda,1,size(signal_matrix,2));

% Estimate the sent data symbols (-1 and 1) 
info_symbol = signal_matrix(:,2);

info_symbol = info_symbol(:);

info_symbol(real(info_symbol) <= 0) = 0;
info_symbol(real(info_symbol) > 0) = 1;

bpsk_symbol = info_symbol;







