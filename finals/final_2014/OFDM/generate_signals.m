% this is a script to generate the input files
% Do not give to the Students

clear all


% OFDM  parameters
Nfft = 256;
cp_size = 20;
delay = 4;
pilot_spacing = 16;


n_pilot=Nfft/pilot_spacing;

% psuedo random BPSK
tx_bit = rand(Nfft,1)>0.5;
tx_symb = 1-2*tx_bit;

% save the pilots
reference_symbols = tx_symb(1:pilot_spacing:end);
%save('ofdm_exam_pilot','reference_symbols');

tx_time = ifft(tx_symb);
tx_time = [tx_time(Nfft-cp_size+1:end); tx_time];

% multipath channel (2 taps)

% delayed path
delayed=zeros(size(tx_time));
delayed(delay:end)=tx_time(1:end-delay+1);

rx_time = (tx_time + delayed)/2;

% save the rx signal
received_OFDM = rx_time;
save('ofdm_exam','received_OFDM', 'reference_symbols');







% (a) Remove the cyclic prefix 
received_OFDM = received_OFDM(cp_size+1:end);
% perform fft
rx_symb =  fft(received_OFDM);

% (b)
Fs=1e3;
Sr=fftshift(abs(fft(received_OFDM,Nfft)));
fplot=-Fs/2:Fs/Nfft:Fs/2-Fs/Nfft;
figure, plot(fplot,Sr), xlabel('Frequency [kHz]'), ylabel('Signal spectrum')



% (c) select the pilot subcarriers
rx_pilot = rx_symb(1:pilot_spacing:end);

% (d) estimate the channel coeficients
least_sqaure_estimate = rx_pilot./reference_symbols;



