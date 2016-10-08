function m_normalized = my_amdemod(s, fc, fs)
%MY_AMDEMOD demodulates the provided AM-modulated signal.
%   MY_AMDEMOD(S, FC, FS) demodulates the AM-modulated signal S.
%   FC is the carrier frequency.
%   FS is the sampling rate of the signal S.

A = 1;
K = 1;
filter_order = 2;

% Get the envelope of the signal
s_abs = abs(s)/A;

%Apply low-pass filter to keep only the baseband copy of e(t)
[b,a] = butter(filter_order,fc/(fs/2),'low'); 
e = filter(b,a,s_abs);

m = (e-1)/K;

m_normalized = normalize_minus_one_to_plus_one(m);

% Normalize the provided sequence with values in [-1;+1]
function normalized = normalize_minus_one_to_plus_one(data)
    minimum = min(data);
    maximum = max(data);
    normalized = 2*(data - minimum)/(maximum - minimum) - 1;
end

end

