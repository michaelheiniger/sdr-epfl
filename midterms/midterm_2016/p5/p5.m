clc;
clear;

% Computes the fucking bound
k = 1:5;
d = k+4;

a = 2.^(k-1);

snr = 5;
snr_dec = 10^(snr/10);
q = qfunc(sqrt(d*snr_dec));
bound = q*transpose(a);


