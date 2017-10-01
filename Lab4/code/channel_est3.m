function lambda = channel_est3(Rf, num_carriers, num_zeros, preamble_symbols, sigma2)

% CHANNEL_EST3 Estimate the channel coefficients in the frequency domain
% There is no channel information available. Ky is estimated from the
% received data

%   RF: matrix containing the received signal, returned by OFDM_RX_FRAME
%   NUM_CARRIERS: number of subcarriers (FFT/IFFT size)
%   NUM_ZEROS: number of zero carriers at either end of the spectrum 
%   PREAMBLE_SYMBOLS: the training sequence
%   SIGMA^2: noise variance 

%   LAMBDA: Column vector containing channel coefficients in the frequency domain


S=diag(preamble_symbols);
Kz=diag(sigma2*ones(num_carriers-2*num_zeros,1));

Y=Rf(:,1); % Get the received preamble OFDM symbol
Ydata=Rf(:,2:end); % Get the other received OFDM symbols

 corMat=zeros(size(Ydata));
 for i=1:size(Ydata,2)
     Col=Ydata(:,i);
     xCol=xcorr(Col,'biased');
     xCol=xCol(length(Col):end);
     corMat(:,i)=xCol;
 end
 
 Ky=toeplitz(mean(corMat,2));
 lambda=((S\(Ky-Kz)) * (Ky\Y));
  
  



