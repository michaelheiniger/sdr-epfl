clear all; close all; clc;

% Software defined Radio 2013

% load the inner products
data = load('innerProducts');

ip = data.ip;


% VARIANTE 1
% determine the bits
bits = zeros(1, length(ip));
bits(1) = -1;

previous_bit = -1;

for i = 2:length(ip)
   if abs(phase(ip(i))-phase(ip(i-1))) <= pi/2
       bits(i) = previous_bit;
   else
       bits(i) = -previous_bit;
       previous_bit = -previous_bit;
   end
end

% Converts -1 to 0
bits(bits == -1) = 0;


% SOLUTION
% determine phase transitions of pi
diff = ip(2:end) .* conj(ip(1:end - 1));
% bit change if diff < 0
diff_b = (real(diff) < 0);
%consider first bit
diff_b=[0, diff_b];
% Integrate to have bits value
b = cumsum(diff_b);
decodedBits = mod(b, 2);

sum(decodedBits ~= bits)