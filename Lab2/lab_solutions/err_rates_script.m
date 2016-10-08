% ERR_RATES_SCRIPT Computes the BER and SER for the selected value of Es/N0
%   for a transmission over the waveform channel with AWGN 
%   Different M-QAM and M-PSK constellations can be easily chosen
%   Validation is provided comparing with the theoretical expressions

clear all;
close all;

%% Parameter selection

N = 1E6; % number of bits to transmit (influence on the accuracy of the BER/SER estimations)

modtype = 'qam'; % 'qam', 'psk'
M = 4; % constellation size: 4, 16, 64

Es_sigma2 = 10; % in dB, ratio of the symbol energy to noise variance at the matched filter output

fprintf(1, 'We transmit %2.2e bits, Modulation is %i-%s, SNR (Es/sigma^2) is %d dB.\n', N, M, modtype, Es_sigma2);

%% 1. Transmitter 

%% 1.1 Design shaping filter (square root raised cosine)
Fd = 1;        % symbol rate 
USF = 5;       % up-sampling factor - should be at least 2 to work (check the bandwidth of the RRC)
Fs = USF * Fd; % sampling frequency
	
beta = 0.22;   % roll-off factor
delay = 8;     % measured in number symbol periods (determines the order of the filter)
               % we are truncating the impulse response to keep 'delay' symbol periods on each side of the central value

order = 2*USF*delay; 
h = firrcos(order, Fd/2, beta, Fs, 'rolloff', 'sqrt'); % notice that the length of the impulse response is order+1
% Equivalently, we could have used the function 'rcosine' to design the filter:
        %h = rcosine(Fd, Fs, 'sqrt/fir', beta, delay); % here the filter is already normalized to norm 1
% Or as Matlab recommends:
        %h = rcosdesign(beta, 2*delay, Fs, 'sqrt'); % here the filter is already normalized to norm 1

% Visualize the filter       
fvtool(h, 'Analysis', 'impulse')   

% Make sure that the filter has norm 1. This way we ensure that the SNR at the channel output and at the output of the matched filter are equal
h = h/norm(h);
	
	% (Un)comment the following lines to hide/plot the impulse response and frequency response of the filter
	figure();
	t = (-delay*USF/Fs:1/Fs:delay*USF/Fs); 
	subplot(2,1,1); plot(t, h); xlabel('t [s]'); ylabel('h(t)'); legend(['\beta = ' num2str(beta)]); grid on;
	NFFT = 2^nextpow2(length(h)); f = linspace(-Fs/2, Fs/2-Fs/NFFT, NFFT);
	subplot(2,1,2); plot(f, abs(fftshift(fft(h, NFFT)))); xlabel('f [Hz]'); ylabel('|H(f)|'); grid on;

%% 1.2 - Generate random bits
tx_bits = randi(2, ceil(N/log2(M)), log2(M)) - 1;
    % the -1 at the end is because randi(2,m,n) returns an m by n matrix with random entries in {1,2}. 

%% 1.3 - Modulate the source bits

% 1.3.1 - Convert bits to M-ary symbols
dec_symbols = my_bi2de(tx_bits);

% 1.3.2 - Get the mapping
switch(lower(modtype))
	case 'qam'
		mapping = my_qammap(M);
	case 'psk'
		mapping = my_pskmap(M);
	otherwise
		error('Unsupported modulation type');
end	
mapping = mapping./sqrt(mean(abs(mapping).^2)); % Normalize constellation to unit average energy - not really necessary
	
% 1.3.3 - Modulator
tx_symbols = my_modulator(dec_symbols, mapping);
Es = mean(abs(tx_symbols).^2); % should be 1 if the constellation has been normalized

figure();
plot(tx_symbols, '*');
grid on; xlabel('Re'); ylabel('Im');title('Tx constellation (unit energy)');


%% 1.4 - From symbols to signals - Shaping filter
tx_signal = my_symbols2samples(tx_symbols, h, USF);

%% 2. Channel: AWGN

 rx_signal = awgn(tx_signal, Es_sigma2, 10*log10(Es)); % or
 % rx_signal = awgn(tx_signal, Es_sigma2-10*log10(USF), 'measured');	

	% If Matlab Comm. Toolbox is not available, we can compute the noise manually using randn: 
     %sigma = sqrt(Es*10^(-Es_sigma2/10)); % Compute the appropriate value for the noise variance
	 %noise = sigma/sqrt(2) * (randn(size(tx_signal)) + 1i*randn(size(tx_signal)));
     %rx_signal = tx_signal + noise;
    
% Note: in both approaches it is assumed that the pulse shaping filter is normalized !
    
%% 3. Receiver

% 3. 1 - Get the sufficient statistics about the transmitted symbols
rx_symbols = my_sufficientstatistics(rx_signal, h, USF);

		% uncomment to get a plot of the constellation at the output of the matched filter (after downsampling)
		figure();
		plot(rx_symbols, '*');
        grid on; xlabel('Re'); ylabel('Im');title('Rx constellation at the output of the matched filter');
			
% 3.2 - Minimum distace demodulator
estim_dec_symbols = my_demodulator(rx_symbols, mapping);
estim_tx_bits = my_de2bi(estim_dec_symbols);

% 3.3 - Compute and display error rates
BER_simulation = sum(estim_tx_bits(:) ~= tx_bits(:))/numel(tx_bits) %#ok<NOPTS>
SER_simulation = sum(estim_dec_symbols ~= dec_symbols)/numel(dec_symbols) %#ok<NOPTS>


    % The two line above assume that we are using 'conv' in my_symbols2samples and my_sufficientstatistics
    % If we use 'filter' instead, then we are losing the transients, and we need to replace the two lines above by:
    % symbol_error_rate = sum(estim_dec_symbols ~= dec_symbols(1:length(estim_dec_symbols)))/numel(estim_dec_symbols);
    % aux = tx_bits(1:length(estim_dec_symbols), :);
    % bit_error_rate = sum(estim_tx_bits(:) ~= aux(:))/numel(aux);	

% For comparison, get theoretical BER /SER values using Matlab Comm. Toolbox function 'berawgn'
% Notice that we need to pass Eb/N0 to this function, not Es/sigma2
Eb_N0 = Es_sigma2 - 10*log10(log2(M)); % N0 = sigma^2 (for complex constellations)
[BER_toolbox_berawgn, SER_toolbox_berawgn] = berawgn(Eb_N0, modtype, M, 'nondiff')  %#ok<NOPTS>
    % The argument 'nondiff' is required for PSK modulations, and it is simply ignored for QAM modulations
            
% There should be a good agreement between the SER values returned by 'berawgn' and those obtained by simulation.
% The BER obtained by simulation will be worse than that returned by the 'berawgn' function, which assumes a Gray
% mapping, while we are using an un-optimized mapping of bits to symbols           
			
% Theoretical values for QPSK/4-QAM modulation can be obtained by simple formulas
if (M == 4)
    es_sigma2 = 10.^(Es_sigma2/10); arg = sqrt(es_sigma2);
    Q = @(x)(0.5 * erfc(x/sqrt(2))); % if you have Matlab Comm. Toolbox you can simply call qfunc() 
    BER_theoretical_QPSK = Q(arg) %#ok<NOPTS> % only exact if the mapping of bits to symbols is Gray
    SER_theoretical_QPSK = 2*Q(arg)-Q(arg).^2 %#ok<NOPTS> % always exact, independently of the mapping of bits to symbols
end
