function lambda = channel_est1(num_carriers, num_zeros, h)

% CHANNEL_EST1 Estimate the channel coefficients in the frequency domain
% The channel is known

%   NUM_CARRIERS: number of subcarriers (FFT/IFFT size)
%   H: channel impulse response; 
%
%   LAMBDA: Column vector containing channel coefficients in the frequency domain
%   contains num_carriers-2*num_zeros elements

% Get the subcarriers coefficients
eigenvalues = eig(h);

% Removes the first num_zeros and last num_zeros values
lambda = eigenvalues(num_zeros+1:end-num_zeros);


 
 
 
