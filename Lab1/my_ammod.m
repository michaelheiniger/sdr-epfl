function s = my_ammod(m, K, A, fc, fs)
%MY_AMMOD AM modulation
%   MY_AMMOD(M, K, A, fc, fs) AM-modulates the signal M.
%   FC is the frequency of the carrier signal
%   FS is the sampling rate of the signal M
%   K and A are constant related to the amplitude of the modulated signal.

% phase of the carrier
phase = 0;

length_m = length(m);
% Time vector
t = linspace(0, (length_m-1)/fs, length_m);

% AM-modulates the signal m
s = A*(1 + K*m).*cos(2*pi*fc*t + phase); 

end

