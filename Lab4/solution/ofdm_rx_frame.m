function Rf = ofdm_rx_frame(rx_signal, num_carriers, num_zeros, prefix_length)

% OFDM_RX_FRAME Receiver for ODFM signals (without channel equalization) 
% RF = OFDM_RX_FRAME(RX_SIGNAL, NUM_CARRIERS, NUM_ZEROS, PREFIX_LENGTH)
%   RX_SIGNAL: vector with the input samples in the time domain
%   NUM_CARRIERS: number of subcarriers (FFT/IFFT size) 
%   NUM_ZEROS: number of zero carriers at either end of the spectrum 
%   PREFIX_LENGTH: length of cyclic prefix (in number of samples) 
%
%   RF: Matrix containing the received OFDM frame. The received symbols are
%   arranged columnwise in a num_carriers x num_ofdm_symbols matrix. After
%   removing the cyclic prefix we go back to frequency domain and also
%   remove the zero carriers.



rx_signal = rx_signal(:);
%rx_signal(1:10)=[];

% compute number of complete OFDM symbols received
num_ofdm_symbols = floor((length(rx_signal))/(num_carriers+prefix_length));
rx_signal=rx_signal(1:num_ofdm_symbols*(num_carriers+prefix_length));

% "remove" cylic prefix:
rx_withCP = reshape(rx_signal((1 : num_ofdm_symbols * (num_carriers + prefix_length))), prefix_length+num_carriers, num_ofdm_symbols); 
rx_noCP = rx_withCP(prefix_length+(1:num_carriers), :); % remove rows corresponding to cyclic prefix

% go to the frequency domain
Rf = fft(rx_noCP, num_carriers);


% remove the zero carriers
Rf = Rf(num_zeros+1:end-num_zeros, :);


