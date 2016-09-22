function s = my_ammod(m, K, A, fc, fs)
%MY_AMMOD Summary of this function goes here
%   Detailed explanation goes here

phase = 0;

% Time vector
duration = length(m)/fs;
t = linspace(0, duration, duration*fs + 1);
% t = 0:1/fs:length(m)/fs-1/fs;

% s is the AM-modulated signal
s = A*(1 + K*m).*cos(2*pi*fc*t + phase); 

end

