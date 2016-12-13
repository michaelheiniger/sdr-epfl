clear;
close all;
clc;

% remove cyclic prefix
% fft
% equalization 
% remove zero-carrier

%load received OFDM signal
load('rx_signal.mat');

%determine the number of OFDM symbols
prefix_length = 4;
num_carriers = 16;
num_zero_carriers = 2;
num_ofdm_sym = length(rx_signal_noisy)/(prefix_length+num_carriers); % = 9 OFDM symbols

% Reshape into matrix
signal_matrix = reshape(rx_signal_noisy, prefix_length+num_carriers, num_ofdm_sym);

% Remove cyclic prefix
signal_matrix_wo_prefix = signal_matrix(prefix_length+1:end,:);

% Apply fft 
NFFT = 16;
signal_matrix_wo_prefix_fft = fft(signal_matrix_wo_prefix, NFFT);

%which are the unused carriers ?
%
signal_matrix_wo_prefix_fft % carriers 4 and 6 are zero-carriers
%

%channel equalization
sufficient_stats = signal_matrix_wo_prefix_fft ./ repmat(D,1,num_ofdm_sym);

% Remove zero-carriers
sufficient_stats = [sufficient_stats(1:3,:); sufficient_stats(5,:);sufficient_stats(7:end,:)];

% Remove preamble
%sufficient_stats = sufficient_stats(:,2:end);

sufficient_stats = sufficient_stats(:);

%determine the constellation for preamble and that for data
% plot(sufficient_stats,'*') % => Modulation is 16-QAM
m = 16;

%determine data bits
MAP = my_qammap(m);
dec= my_demodulator(sufficient_stats(num_carriers-num_zero_carriers+1:end), MAP);

%convert data bits to text (8 consecutive  bits represent one character)
% invert de2bi(unicode2native(),8)
bits = transpose(de2bi(dec));

bits = bits(:);
bits = transpose(reshape(bits, 8, []));

transpose(native2unicode(bi2de(bits)))


