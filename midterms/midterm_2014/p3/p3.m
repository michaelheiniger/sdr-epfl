clc;
clear;


Es_N0_dB = 10;
image_file = 'einstein.pgm';
M = 16;
l=log2(M);

% Transmitter
bits = my_img2bit(image_file);

[symbols, mapping] = my_mapper(bits, M);

% AWGN 
symbols_received = awgn(symbols,Es_N0_dB,'measured');

estim_bits = my_demapper(symbols_received,mapping);
BER = sum(estim_bits(:) ~= bits(:))/numel(bits) ; 

% display result
disp('BER:');
disp(BER);
