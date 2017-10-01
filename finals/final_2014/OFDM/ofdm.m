clear all; close all; clc;

% OFDM  parameters
NFFT = 256;
cp_size = 20;
pilot_spacing = 16;
load ofdm_exam


% (a) Remove the cyclic prefix 

ofdm_frame_width = length(received_OFDM)/(NFFT+cp_size);
ofdm_frame_cp = reshape(received_OFDM, NFFT+cp_size, ofdm_frame_width);

% Remove CP
ofdm_frame = ofdm_frame_cp(cp_size+1:end,:);

ofdm_frame_fft = fft(ofdm_frame, NFFT);

% (b) Plot the absolute value of the frequency spectrum
fs = 1e6;
freq = linspace(-fs/2, fs/2-fs/NFFT, NFFT)/1000;
ofdm_frame_fft_shifted = abs(fftshift(ofdm_frame_fft));
plot(freq, ofdm_frame_fft_shifted);
xlabel('frequency [kHz]');

% (c) estimate the channel coeficients
ref_symbol_indices = 1:256;
ref_symbol_indices = ref_symbol_indices(mod(ref_symbol_indices, 16) == 1);

reference_symbols_rx = ofdm_frame_fft(ref_symbol_indices);

lambda_ref_symbols = reference_symbols_rx ./ reference_symbols;


