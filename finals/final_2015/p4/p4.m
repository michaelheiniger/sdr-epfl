clc;
clear;

load('ofdm_rx_signal.mat');
load('clean_rx_signal.mat');

ofdm_rx_signal = transpose(ofdm_rx_signal);

num_carriers = 256;
length_cp = 25;
max_number_symbols = floor(length(ofdm_rx_signal)/(num_carriers+length_cp))-1;

length_symbol_w_cp = num_carriers + length_cp;

best_i = 0;
max_sum_ip = 0;
for i = 1:length_symbol_w_cp-1
  
    trunc_signal = ofdm_rx_signal(i:end);
   
    sum_ip = 0;
    for j = 1:length_symbol_w_cp:max_number_symbols*length_symbol_w_cp
        prefix_1 = trunc_signal(j:j+length_cp-1);
        prefix_2 = trunc_signal(j+num_carriers:j+num_carriers+length_cp-1);
        ip = sum(prefix_1.*conj(prefix_2));
        sum_ip = sum_ip + ip;
    end
    
    if sum_ip > max_sum_ip
        max_sum_ip = sum_ip;
        best_i = i;
    end
end

truncated_signal = ofdm_rx_signal(best_i:end);

% Remove end bits
truncated_signal = truncated_signal(1:max_number_symbols*length_symbol_w_cp);


% b)
signal_matrix_cp = reshape(truncated_signal, num_carriers+length_cp, []);
signal_matrix = signal_matrix_cp(length_cp+1:end,:);
signal_matrix_fft = fft(signal_matrix, num_carriers);

symbols = signal_matrix_fft(:);

plot(symbols,'*');





