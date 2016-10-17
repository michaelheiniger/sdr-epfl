function lambda = channel_est1(num_carriers, num_zeros, h)

% CHANNEL_EST1 Estimate the channel coefficients in the frequency domain
% The channel is known

%   NUM_CARRIERS: number of subcarriers (FFT/IFFT size)
%   H: channel impulse response; 
%
%   LAMBDA: ROW vector containing channel coefficients in the frequency domain
%   contains num_carriers-2*num_zeros elements

v =  [ h(1), zeros(1,num_carriers-length(h)), fliplr(h(2:end))];
%H = fft(toeplitz([v(1) fliplr(v(2:end))], v), num_carriers) \dftmtx(num_carriers);
H = eig(toeplitz([v(1) fliplr(v(2:end))], v));

lambda_with_guard_subcarriers = H; %diag(H);
lambda = transpose(lambda_with_guard_subcarriers(num_zeros+1:end-num_zeros));
end