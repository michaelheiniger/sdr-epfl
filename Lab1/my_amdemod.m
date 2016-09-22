function m_normalized = my_amdemod(s, fc, fs)
%MY_AMDEMOD Summary of this function goes here
%   Detailed explanation goes here

K = 1;
filter_order = 2;

% Take absolute value of the signal
s_abs = abs(s);

%Apply low-pass filter to keep only one copy of e(t)
[b,a] = butter(filter_order,fc/(fs/2),'low'); % ??? 
e = filter(b,a,s_abs);

m = (e-1)/K;

m_normalized = m/max(m);

end

