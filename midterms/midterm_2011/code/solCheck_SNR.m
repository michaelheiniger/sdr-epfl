%tx are symbols from a 4QAM constellation, which are sent over an awgn
%channel
%rx are the noise affected received signals
%rate is the encoding rate of the original bits.It should be between 0 
%and 1. If it is not specified, it is assumed to be 1.
load('signals_midterm.mat');

% b. Determine SNR

r = 1;

noise=rx-tx;

%noise power
N0=mean(abs(noise.^2));

%signal power
Es=mean(abs(tx.^2));

Es_N0=10*log10(Es/N0)


% c. Determine Eb_N0

nb=2;  %2 bits per symbol for 4QAM

Eb_N0=Es_N0-10*log10(nb)-10*log10(r)

%-10*log10(M) compensates for the fact that there are M coded bits per
%modulation symbol

% As r<1, 10*log10(r)<0. This term compensates for the fact that more
% encoded bits are transmitted for each uncoded bit. Since the overall
% energy is the same, the energy of an encoded bit is higher than the
% energy of each coded bi
