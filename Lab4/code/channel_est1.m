function lambda = channel_est1(num_carriers, num_zeros, h)

% CHANNEL_EST1 Estimate the channel coefficients in the frequency domain
% The channel is known

%   NUM_CARRIERS: number of subcarriers (FFT/IFFT size)
%   H: channel impulse response; 
%
%   LAMBDA: ROW vector containing channel coefficients in the frequency domain
%   contains num_carriers-2*num_zeros elements

lambda = fft(h, num_carriers);
lambda = lambda(num_zeros+1:end-num_zeros);
end