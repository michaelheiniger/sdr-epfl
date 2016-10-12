% TEST_OFDM Script to test the OFDM transmitter / channel / receiver


clear; close all; 
clc

% System parameters
num_carriers = 256;    % total number of carriers
num_zeros = 5;         % number of unsused carriers (at each end of the frequency spectrum)
prefix_length = 25;    % length of the cyclic prefix
num_ofdm_symbols = 10000; % number of OFDM symbols per frame (1 will be used to transmit the preamble and the rest for data)
M_preamble = 4;        % we use 4-QAM for the preamble
M_data = 4;           % we use 4-QAM for the data

SNR = 30; % in dB

% Derived parameters
num_useful_carriers = num_carriers - 2 * num_zeros;

constel_preamble = my_qammap(M_preamble);
% constel_preamble = constel_preamble /  var(constel_preamble,1);  '1' parameter to use the biased estimator

constel_data = my_qammap(M_data);
% constel_data = constel_data /  var(constel_data,1);  '1' parameter to use the biased estimator

% Transmitter
% Generate preamble and data
preamble = randi([0, M_preamble-1], [num_useful_carriers, 1]);
preamble_symbols = my_modulator(preamble, constel_preamble);
%preamble_symbols=ones(size(preamble_symbols));



data = randi([0, M_data-1], [num_useful_carriers * (num_ofdm_symbols-1), 1]);
data_symbols = my_modulator(data, constel_data);

E_s=var(constel_data,1);  % average energy of data symbols; '1' parameter to use the biased estimator

% Generate OFDM signal to be transmitted
% tx_signal = sol_ofdm_tx_frame(num_carriers, num_zeros, prefix_length, preamble_symbols, data_symbols); % Comment this line when you have finished coding the ofdm_tx_frame.m
tx_signal = ofdm_tx_frame(num_carriers, num_zeros, prefix_length, preamble_symbols, data_symbols); % Uncomment this line when you have finished coding the ofdm_tx_frame.m
E_tx=var(tx_signal); % power of transmitted signal

% Channel

channel_length = prefix_length+1; % it should fulfill channel_length <= prefix_length+1

% random impulse response for test purposes
%h = 1/sqrt(2) * (randn(1,channel_length) + 1i*randn(1,channel_length)); 
%h=randn(1,channel_length);


%  multipath channel described in class
% amplitudes = randn(1,4); %Gaussian distribution, N(0,1) 
delays = [0 0.5 1.2 1.4];
% h = create_multipath_channel_filter(amplitudes, delays);

% simple channel 
% which just adds WGN (non frequency selective channel, i.e, no ISI).
% to use it, uncomment the following line
h = [1 zeros(1,channel_length-1)]; 

% normalize impulse response
h = h/norm(h);

if (length(h) > prefix_length+1)
     warning('test_ofdm:impulseResponseTooLong', 'The channel impulse response is greater than the channel length, it will create ISI');
end

% convolve tx_signal with channel impulse response
rx_signal = conv( tx_signal,h);

% add AWGN
sigma = 10^(-SNR/20) * sqrt(E_tx);
noise = sigma/sqrt(2)* (randn(size(rx_signal)) + 1i*randn(size(rx_signal)));

rx_signal_noisy = rx_signal + noise;

% Receiver
Rf = sol_ofdm_rx_frame(rx_signal_noisy, num_carriers, num_zeros, prefix_length); % Comment this line when you have finished coding the ofdm_rx_frame.m
%Rf = ofdm_rx_frame(rx_signal_noisy, num_carriers, num_zeros, prefix_length); % Uncomment this line when you have finished coding the ofdm_rx_frame.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%Channel coefficient estimation

% h known
lambda1 = sol_channel_est1(num_carriers, num_zeros, h); % Comment this line when you have finished coding the channel_est1.m
%lambda1 = channel_est1(num_carriers, num_zeros, h); % Uncomment this line when you have finished coding the channel_est1.m

% delays and variances known
sigma2=num_carriers*sigma^2; %the fft transform increases the noise variance!
lambda2 = channel_est2(Rf, num_carriers, num_zeros, preamble_symbols, delays, sigma2); 

% no channel information known, we estimate Ky from the data
lambda3 = channel_est3(Rf, num_carriers, num_zeros, preamble_symbols, sigma2); 

% no channel information known, we use the pedestrian approach of dividing
% the chennel output by the preamble
lambda4 = channel_est4(Rf, preamble_symbols);


%We determine the variance of each estimate (or the error)
%Note: The differences between channel_est3 and channel_est4 are
%visible at low values of SNR. 
var2=var(lambda1-lambda2.')
var3=var(lambda1-lambda3.')
var4=var(lambda1-lambda4.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Channel equalization, demodulation and determining SER


%- The channel response is assumed to remain constant during the whole frame

eq_signal1 = Rf .* repmat(1./lambda1(:), 1, num_ofdm_symbols); 
suf_statistics1 = eq_signal1(:); 
estim_data1 = my_demodulator(suf_statistics1(length(preamble_symbols)+1:end), constel_data);
SER1 = sum(estim_data1 ~= data) / numel(data) %#ok<NOPTS>

    % debugging information
    suf_data1=suf_statistics1(length(preamble_symbols)+1:end);
    figure(); plot(suf_data1, '.b'); xlabel('Re'); ylabel('Im'); title('Received constellation after OFDM demodulation and equalization');
    hold on; plot(constel_data, 'or'); legend('Received constellation', 'Transmitted constellation');

eq_signal2 = Rf .* repmat(1./lambda2, 1, num_ofdm_symbols); 
suf_statistics2 = eq_signal2(:); 
estim_data2 = my_demodulator(suf_statistics2(length(preamble_symbols)+1:end), constel_data);
SER2 = sum(estim_data2 ~= data) / numel(data) %#ok<NOPTS>

eq_signal3 = Rf .* repmat(1./lambda3, 1, num_ofdm_symbols); 
suf_statistics3 = eq_signal3(:);  
estim_data3 = my_demodulator(suf_statistics3(length(preamble_symbols)+1:end), constel_data); % returns decimal numbers in 0 .. length(constel_data) - 1
SER3 = sum(estim_data3 ~= data) / numel(data) %#ok<NOPTS>


eq_signal4 = Rf .* repmat(1./lambda4, 1, num_ofdm_symbols); 
suf_statistics4 = eq_signal4(:);  
estim_data4 = my_demodulator(suf_statistics4(length(preamble_symbols)+1:end), constel_data); % returns decimal numbers in 0 .. length(constel_data) - 1
SER4 = sum(estim_data4 ~= data) / numel(data) %#ok<NOPTS>

