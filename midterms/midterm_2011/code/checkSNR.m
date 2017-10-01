function [Es_N0, Eb_N0] = checkSNR(tx, rx, r)

%tx are symbols from a 4QAM constellation, which are sent over an awgn
%channel
%rx are the noise affected received signals
%rate is the encoding rate of the original bits.It should be between 0 
%and 1. If it is not specified, it is assumed to be 1.



% a. Input parameter check
if ~exist('r','var')
    r = 1;
elseif r < 0 || r > 1
   error('r should be between 0 and 1 !'); 
end



% b. Determine Es_N0
Es = sum(tx.*conj(tx))/length(tx);
N0 = sum((rx-tx).*conj(rx-tx))/length(rx);

Es_N0 = 10*log10(Es/N0); %dB

% c. Determine Eb_N0

Eb = Es/(r*2);
Eb_N0 = 10*log10(Eb/N0);

	
end 