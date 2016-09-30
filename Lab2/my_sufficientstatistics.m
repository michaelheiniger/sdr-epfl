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



Y = conv(R,G);

delay = (length(H)-1)/2 * 2; 

% Downsample the signal removing transients
X = Y(delay+1:USF:end-delay); 



end

