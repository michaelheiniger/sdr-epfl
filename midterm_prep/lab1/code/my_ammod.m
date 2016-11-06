function [ s ] = my_ammod(m, K, A, fc, fs)
%MY_AMMOD AM modulation
%   MY_AMMOD(m, K, A, fc, fs) AM-modulates the signal m

% Issue a warning if the constant K is too large
if (K * max(abs(m)) > 1)
    warning('K must be such that |K * m(t)| <= 1');
end

% Tranpose m if needed
[rows, ~] = size(m);
if rows > 1
   m = transpose(m);
end
% Time axis: needed for the carrier signal
t = linspace(0, (length(m)-1)/fs, length(m));

% Carrier signal
carrier = cos(2*pi*fc*t);

% Up conversion of m by mutiplying by the carrier
s = A*(1+K*m) .* carrier; 

end

