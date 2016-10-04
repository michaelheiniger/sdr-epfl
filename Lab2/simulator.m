clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tx/Rx common parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Energy per symbol
Es = 1;
No = 1000;
EsNo = Es/No;

% Size of constellation
M = 4;
MAP = my_qammap(M);

% Basic Pulse (Root-Raised Cosine Function)
BETA = 0.22; % Roll-off factor
SPAN = 6; % ???
SPS = 4; % ???
H = rcosdesign(BETA, SPAN, SPS); % Already normalized

% Since no signal is actually converted to analog, the data rate is
% meaningless. It actually depends on the speed of the CPU (doesn't it?).
%fs = 4000; % [Hz]
%tau = (SPAN*SPS + 1)/fs; % [seconds] = width of main lobe of pulse
% Bandwidth occupied by rrcos is (1+beta)*(1/tau) = (1+beta)/tau (?)
%bandwidth = (1+BETA)/tau; % Hz

%symbols_per_second = 1/tau
%bits_per_second = (1/tau)*log2(M)
% This makes 1/tau symbols/s and thus log2(M)/tau bits/s (?)

% Upsampling factor
USF = SPS * SPAN + 1; % Number of samples per symbol (?)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tx side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Generate a random message
N = 10e4; % Number of bits to transmit. Must be a multiple of log2(M)
if mod(N/log2(M),1) ~= 0
   error('N must be a multiple of log2(M).'); 
end
% Generate random decimal numbers in [0;M-1] to simulate the incoming data
% Decimal numbers are generated instead of bits (easier to do)
X_dec = randi(M, 1, N/log2(M))-1; % Message in decimal in [0; M-1]
X_bits = dec2bin(X_dec); % Corresponding bits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert the bits into decimal values for the modulator
X = bin2dec(X_bits);

% Modulation to obtain the symbols
Y = my_modulator(X, MAP) * sqrt(Es/2); % Scales with energy per symbol Es

% Association of symbols with pulses to get the samples to transmit
Z = my_symbols2samples(Y, H, USF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation of channel (AWGN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Energy-per-symbol to noise variance ratio: E_s/sigma²
snr = 10*log10(EsNo); % dB  

% Add Gaussian Noise of variance Es/No in dB
R = awgn(Z, snr);

% "Transmission"
% ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rx side
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Obtain the sufficient statistics to recover the symbols
Y_rec = my_sufficientstatistics(R, H, USF) / sqrt(Es/2);

% Display the recovered symbol on an M-QAM plane
sPlotFig = scatterplot(Y_rec ,1,0,'g.');
set(gca, 'XAxisLocation', 'origin')
set(gca, 'YAxisLocation', 'origin')
hold on;
scatterplot(my_qammap(M),1,0,'k*',sPlotFig);

% Recover the symbols
X_rec_dec = my_demodulator(Y_rec, MAP);

% Recover the bits
X_rec_bits = dec2bin(X_rec_dec);

% Bit Error Calculation
absolute_errors = sum(sum((X_bits ~= X_rec_bits))); % Sum is used twice to sum on both dimensions
BER = absolute_errors/(size(X_bits,1) * size(X_bits,2)) % Actual
Pb = qfunc(sqrt(EsNo)) % Theoretical

% Symbol Error Calculation for 4-QAM
absolute_symbol_errors = sum(X_dec ~= X_rec_dec);
SER = absolute_symbol_errors/length(X_dec) % Actual
Ps = 2*qfunc(sqrt(EsNo)) - qfunc(sqrt(EsNo))*qfunc(sqrt(EsNo)) % Theoretical

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis of the results:
% With an Es/No of 1/1000 (i.e. -30 dB) we have
% an actual BER of 0.4898 and a theoretical bit error proba of 0.4874
% an actual SER of 0.7396 and a theoretical symbol error proba of 0.7372
% In both cases, the empirical and theoretical figures are strikingly
% close. 
% The results seem good, however errors or inconsistencies 
% (or at least optimization are possible) are most likely since there 
% are many aspects that still elude me even after 
% a lot of reading and thinking...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%