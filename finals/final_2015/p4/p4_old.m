clc;
clear;

load('ofdm_rx_signal.mat');
load('clean_rx_signal.mat');

ofdm_rx_signal = transpose(ofdm_rx_signal);

num_carriers = 256;
length_cp = 25;
max_number_symbols = floor(length(ofdm_rx_signal)/(num_carriers+length_cp))-1;

length_symbol = num_carriers + length_cp;

max_index = 0;
max_corr = 0;
for i = 1:length_symbol+1
  
    trunc_signal = ofdm_rx_signal(i:end);
    mask = zeros(1, max_number_symbols*(num_carriers+length_cp));
    for j = 1:length_symbol:max_number_symbols*length_symbol
        prefix_1 = trunc_signal(j:j+length_cp-1);
        zero = zeros(1, num_carriers-length_cp);
        prefix_2 = trunc_signal(j+num_carriers:j+num_carriers+length_cp-1);
        mask(j:j+length_symbol-1) = [prefix_1, zero, prefix_2];
    end
    
    [R, ~] = xcorr(ofdm_rx_signal, mask);
    R = R(1:length(ofdm_rx_signal));
    [corr, index] = max(abs(R));
    
    if corr > max_corr
        max_corr = corr;
        max_index = i;
    end
end

truncated_signal = ofdm_rx_signal(max_index:end);
length(truncated_signal)


