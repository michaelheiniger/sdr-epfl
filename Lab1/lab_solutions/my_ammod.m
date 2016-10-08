% MY_AMMOD Performs amplitude modulation
%    S = MY_AMMOD(M, K, A, Fc, Fs) is an amplitude modulated signal of the 
%    message signal M(t), where Fs is the sampling frequency of the message
%    signal and Fc is the desired carrier frequency. The modulation is
%    performed as follows:
%      S = A * (1 + K*M(t)) * cos(2*pi*Fc*t)

function s = my_ammod(m, K, A, fc, fs)

% Issue a warning if the constant K is too large
if (K * max(abs(m)) > 1)
    warning('K must be such that |K * m(t)| <= 1');
end

% Extract time vector from signal and sampling frequency
t = linspace(0, (length(m)-1) / fs, length(m));

% Compute the modulated signal
s = A * (1 + K * m) .* cos(2*pi*fc*t);

end
