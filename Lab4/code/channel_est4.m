
function lambda = channel_est4(Rf, preamble_symbols)

% CHANNEL_EST4 Estimate the channel coefficients in the frequency domain
% There is no channel information available. The channel coefficients are
% computed as the ratio between the first received OFDM symbol and the
% preamble

%   RF: matrix containing the received signal, returned by OFDM_RX_FRAME
%   PREAMBLE_SYMBOLS: the training sequence

%   LAMBDA: Column vector containing channel coefficients in the frequency domain


%Select the received symbol corresponding to the preamble
 Y=Rf(:,1);

%estimate the channel coefficients 
 lambda=Y./preamble_symbols;

