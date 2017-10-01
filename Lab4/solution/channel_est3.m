function lambda = channel_est3(Rf, num_carriers, num_zeros, preamble_symbols, sigma2)

% CHANNEL_EST3 Estimate the channel coefficients in the frequency domain
% There is no channel information available. Ky is estimated from the
% received data

%   RF: matrix containing the received signal, returned by OFDM_RX_FRAME
%   NUM_CARRIERS: number of subcarriers (FFT/IFFT size)
%   NUM_ZEROS: number of zero carriers at either end of the spectrum 
%   PREAMBLE_SYMBOLS: the training sequence
%   DELAY: vector containing the delay for eah path in the multipath filter
%   SIGMA^2: noise variance 

%   LAMBDA: Column vector containing channel coefficients in the frequency domain

% prepare the matrices as in the lecture notes
S = diag(preamble_symbols); 


Y = Rf(:,1); % the training sequence
Ydata = Rf(:,2:end); % the data
 
X = preamble_symbols;
alpha = mean((real(Y)-imag(Y)) ./ (2*imag(X)));

noiseVariance = mean(imag(Y).^2 - 2*alpha*imag(X).*imag(Y) + (alpha*imag(X)).^2)

% noiseVariance2 = mean(9/4*real(Y).^2 - 3/2*real(Y).*imag(Y)+1/4*imag(Y).^2)


Kz = diag(sigma2*ones(num_carriers-2*num_zeros,1));
% Kz = diag(noiseVariance<*ones(num_carriers-2*num_zeros,1));
sigma2

% extract Ky from the data
 % the xcorr command is actually computing an estimate of the correlation, see help xcorr
 corMat = zeros(size(Ydata));
 for i = 1:size(Ydata,2)
     Col = Ydata(:,i);
     xCol = xcorr(Col,'biased');
     xCol = xCol(length(Col):end);
     corMat(:,i) = xCol;
 end
 
 Ky = toeplitz(mean(corMat,2)); % the correlation matrix is Toeplitz - by definition. We also average over the data (over the OFDM symbols)
 lambda = ((S\(Ky-Kz)) * (Ky\Y)); % as in the lecture notes
  
  



