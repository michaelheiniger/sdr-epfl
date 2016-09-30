function [ C ] = my_pskmap( M )
% MY_PSKMAP Creates constellation for Phase Shift Keying modulation
% C = MY_PSKMAP(M) outputs a 1×M vector with the complex symbols
% of the PSK constellation of alphabet size M, where M is an integer power of 2.


% Check if M is a power of 2 (required for a PSK, by definition)
if (not(is_number_integer(log2(M))) || M <= 1)
    error('M must be a power of 2 greater than than 1');
end

step = 360/M;
angles = 0:step:360-step;
cosines = cosd(angles);
sines = sind(angles);

C = cosines + i*sines;


function result = is_number_integer(n)
    result = (mod(n,1) == 0);
end
end

