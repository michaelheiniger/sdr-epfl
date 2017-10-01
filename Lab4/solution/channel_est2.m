function lambda = channel_est2(Rf, num_carriers, num_zeros, preamble_symbols, delays, sigma2)

% CHANNEL_EST2 Estimate the channel coefficients in the frequency domain
% The channel delays are known. The amplitude distribution is also known.
% Example given in Appendix C

%   RF: matrix containing the received signal, returned by OFDM_RX_FRAME
%   NUM_CARRIERS: number of subcarriers (FFT/IFFT size) 
%   NUM_ZEROS: number of zero carriers at either end of the spectrum 
%   PREAMBLE_SYMBOLS: the training sequence
%   DELAY: vector containing the delay for eah path in the multipath filter
%   SIGMA^2: noise variance 

%   LAMBDA: Column vector containing channel coefficients in the frequency domain

%Select the received symbol corresponding to the preamble
Y = Rf(:,1);
 
%build matrix R
L = max(ceil(delays))+1;
M = numel(delays);
R = zeros(num_carriers,M);

R1 = repmat([0:L-1]',1,M);
R1 = 1-abs(R1-repmat(delays, L,1));
R1(R1<0) = 0;
R(1:L,:) = R1;

%estimate Kd, Kdy, Ky
S = diag(preamble_symbols);
Kz = diag((sigma2)*ones(num_carriers-2*num_zeros,1));
Ka = eye(M);%amplitudes  drawn from N(0,1)

Kd = fft(R, num_carriers)*Ka*fft(R, num_carriers)';
Kd = Kd(num_zeros+1: end-num_zeros,num_zeros+1: end-num_zeros);
Kdy = Kd*S';
Ky = S*Kd*S'+Kz;

%estimate lambda
lambda = Kdy*(Ky\Y);


