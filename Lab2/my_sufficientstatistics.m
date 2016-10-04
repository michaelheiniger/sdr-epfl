function [ X ] = my_sufficientstatistics( R, H, USF )
% MY_SUFFICIENTSTATISTICS Processes the output of the channel to generate
% sufficient statistics about the transmitted symbols.
% X = MY_SUFICIENTSTATISTICS(R, H, USF) produces sufficient statistics
% about the transmitted symbols, given the signal received in vector R,
% the impulse response H of the basic pulse (transmitting filter), and
% the integer USF, which is the ratio between the sampling rate and the
% symbol rate (upsampling factor)

% G[n] = H*[-n]
G = conj(fliplr(H));

% Convolution between the received signal R and the matched filter 
% (which is not causal, see delay correction below)
Y = conv(R,G);

% Accounts for both the original pulse and its counterpart used for the 
% matched filter 
delay = length(H) - 1; 

% Downsample the signal to account for the upsampling in
% my_symbols2samples.m
X = Y(delay+1:USF:length(Y)-delay); 



end

