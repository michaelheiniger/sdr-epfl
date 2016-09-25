function m_normalized = my_amdemod(s, fc, fs)
%MY_AMDEMOD demodulates the provided AM-modulated signal.
%   MY_AMDEMOD(S, FC, FS) demodulates the AM-modulated signal S.
%   FC is the carrier frequency.
%   FS is the sampling rate of the signal S.

A = 1;
K = 1;
filter_order = 2;

% Take absolute value of the signal
s_abs = abs(s)/A;

%Apply low-pass filter to keep only one copy of e(t)
[b,a] = butter(filter_order,fc/(fs/2),'low'); % ??? 
e = filter(b,a,s_abs);


m = (e-1)/K;

m_normalized = m/max(abs(min(m)),abs(max(m)));
% m_normalized = m;

end

