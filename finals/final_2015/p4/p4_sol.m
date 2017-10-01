% Script for OFDM synchronization using the cyclic prefix

clear; close all; clc;

num_carriers = 256;    % total number of carriers
prefix_length = 25;    % length of the cyclic prefix

file_name = 'ofdm_rx_signal.mat';

% load the file and signal
aux = load(file_name);
ofdm_signal = aux.ofdm_rx_signal;

% load the clean signal
% aux = load('clean_rx_signal');
% ofdm_signal = aux.clean_rx_signal;

size_ofdm_signal = size(ofdm_signal)

% number of symbols to be used during the estimation
corr_symbols = floor(length(ofdm_signal)/(num_carriers+prefix_length)) - 1

% we loop and do a correlation (IP) trying to find the beginning of an OFDM symbol (including cyclic prefix)
% we need to try to find the beginning over a length of at least num_carriers+prefix_length-1
corr_results = zeros(1, num_carriers+prefix_length-1);

for j = 1:length(corr_results)
    
    % get data equivalent to corr_symbols length
    data_aux = ofdm_signal(j: j+(num_carriers+prefix_length)*corr_symbols-1);
    
    % reshape, copy the cyclic prefix to the end, and set everything else
    % to zero
    data_aux1 = reshape(data_aux, num_carriers+prefix_length, corr_symbols);
    data_aux1(end-prefix_length+1:end,:) = data_aux1(1:prefix_length,:);
    data_aux1(1:end-prefix_length,:) = 0;
  
    data_corr = reshape(data_aux1,1,[]); % make a row vector
    
    % do the inner product
    corr_tmp = conj(data_corr)*data_aux;
    corr_results(j) = abs(corr_tmp);
    
end

% plot corr_results to check the peak
figure;
plot(corr_results,'-*');
xlabel('Start index');
ylabel('Inner Product');
title('Correlation with cyclic prefix');
grid on;

[~, indd] = max(corr_results);
start_frame_index = indd

dropped_symbols = mod(num_carriers+prefix_length - indd + 1, num_carriers+prefix_length)


rx_data = ofdm_signal(indd:end); % remove the start symbols
no_full_symbols = floor(length(rx_data)/(num_carriers+prefix_length)) % how many OFDM complete super-symbols we have
rx_data = rx_data(1:no_full_symbols*(num_carriers+prefix_length)); % remove the end symbols

size_rx_data_synchronized = size(rx_data)

% OFDM receiver

% reshape the data
data_rx_withCP = reshape(rx_data,num_carriers+prefix_length, no_full_symbols);
% remove the cyclic prefic
data_rx_noCP = data_rx_withCP(prefix_length+1:end,:);
% do the FFT
Rf = fft(data_rx_noCP, num_carriers);

figure;
plot(Rf(:),'*');
xlabel('Real');
ylabel('Imag');
title('Received constellation');
grid on;
