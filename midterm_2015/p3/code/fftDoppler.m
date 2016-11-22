function dopplerEstimate = fftDoppler(sat,startOfBit)

gpsConfig();
global gpsc;

% load one bit worth of data
r = 

% remove the C/A code so that the result is only a carrier 
rc =

% append zeros at the end of rc to decrease the step size in the fft domain 

rcExtended = 

% move to Fourier domain
rcF = 

% test
figure(1)
stem(abs(rcF))
% you can remove the above test if you wish


% find the position of the strongest component

% find the corresponding frequency
% (fill in)
dopplerEstimate =

% to show that you know what your resolution is ...
resolution = 
sprintf('My resolution is: %d Hz', resolution)
end
