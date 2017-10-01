function dopplerEstimate = fftDoppler(sat,startOfBit)

gpsConfig();
global gpsc;

desired_resolution = 10; % in Hz

% load one bit worth of data
r = getData(startOfBit,startOfBit+gpsc.spb-1);

% remove the C/A code so that the result is only a carrier 
ca_code = satCode(sat,'fs');
ca_code_bit = repmat(ca_code, 1, gpsc.cpb);
rc = r.*ca_code_bit;

% append zeros at the end of rc to decrease the step size in the fft domain 

rcExtended = 

% move to Fourier domain
rcF = fft(rcExtended);

% test
figure(1)
stem(abs(rcF))
% you can remove the above test if you wish


% find the position of the strongest component
[~,pos] = max(abs(rcF))

% find the corresponding frequency
% (fill in)
dopplerEstimate =

% to show that you know what your resolution is ...
resolution = 
sprintf('My resolution is: %d Hz', resolution)
end
