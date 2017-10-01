% OFDM  parameters
Nfft = 256;
cp_size = 20;
pilot_spacing = 16;
load ofdm_exam
Fs=1e3; % fs=1e6/1000 = 1e3 to be in kHz instead of Hz

% (a) Remove the cyclic prefix 
received_OFDM = received_OFDM(cp_size+1:end);
% perform fft
rx_symb =  fft(received_OFDM);


% (b) Plot the absolute value of the frequency spectrum
Sr=fftshift(abs(fft(received_OFDM,Nfft)));
fplot=-Fs/2:Fs/Nfft:Fs/2-Fs/Nfft;
figure, plot(fplot,Sr), xlabel('Frequency [kHz]'), ylabel('Signal spectrum')

% (c) estimate the channel coeficients
received_pilots = rx_symb(1:pilot_spacing:end);
channel_estimate = received_pilots./reference_symbols


% Plot -- it is not in the exam
% subcarier_spacing = Fs/Nfft % in kHz ;
% pilot_spacing  =  subcarier_spacing * pilot_spacing
% pilot_frequecy = -Fs/2:pilot_spacing:Fs/2-Fs/Nfft ; 
% hold on;
% plot(pilot_frequecy,fftshift(abs(channel_estimate)),'+r')


