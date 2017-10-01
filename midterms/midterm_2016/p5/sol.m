
clear all; close all;

% create i, d and a: for each i, there is only one d in the sum
i = 1:5;
d = i+4;
a = 2.^(i-1);

SNR  = 5; % in dB
SNRdec = 10^(SNR/10);

% implement the given formula
BER_theoretical = qfunc(sqrt(d*SNRdec)) * (i.*a)'

% now we simulate

n=1e7;
bits=randi(2,1,n)-1;

constraint_length=3;
generator=[5,7];
trellis=poly2trellis(constraint_length,generator);
coded_bits=convenc(bits,trellis);

%channel input
coded_symbols=-coded_bits*2+1;

% channel output
y=awgn(coded_symbols,SNR,'measured');

% decoder
trace_back_length=15;
s_est=vitdec(y,trellis,trace_back_length,'trunc','unquant');

BER_simulated = sum(abs(bits-s_est))/n