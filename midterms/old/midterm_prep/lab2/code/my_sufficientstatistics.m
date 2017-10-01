% MY_SUFFICIENTSTATISTICS Processes the output of the channel to generate
% sufficient statistics about the transmitted symbols.
% X = MY_SUFICIENTSTATISTICS(R, H, USF) produces sufficient statistics
% about the transmitted symbols, given the signal received in vector R,
% the impulse response H of the basic pulse (transmitting filter), and
% the integer USF, which is the ratio between the sampling rate and the
% symbol rate (upsampling factor)
function [ x ] = my_sufficientstatistics(r, h, usf)

% conjugate of phi(-t)
h_reverse = conj(fliplr(h)); 

% Matched filted output "before sampling"
y = conv(r, h_reverse);

% "Sampling" matched filter output:
% USF = N = (1/Ts)/(1/T) = T/Ts
% Sufficient stats are every kT samples for k=1,2,...,K (i.e. every USF)
x = y(length(h):usf:end-length(h)+1); 

end

