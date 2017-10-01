function dopplerEstimate = fftDoppler_sol(sat,startOfBit)

gpsConfig();
global gpsc;

desired_resolution = 1; % in Hz

% load one bit worth of data
r = getData(startOfBit, startOfBit+gpsc.spb - 1);

% remove the C/A code so that the result is only a carrier 
rc = r.*repmat(satCode(sat,'fs'),1,gpsc.cpb);

% append zeros at the end of rc to decrease the step size in the fft domain 
rcExtended = zeros(1, ceil(gpsc.fs/desired_resolution));
rcExtended(1:gpsc.spb) = rc;

% move to Fourier domain
rcF = fft(rcExtended);

% test
figure(1)
plot(abs(rcF))
% you can remove the above test if you wish


% find the position of the strongest component
% (fill in)
[~, pos] = max(abs(rcF));

% find the corresponding frequency
if pos > length(rcF)/2 % the negative frequencies are in the second half of rcF
    pos = pos - length(rcF); 
end

dopplerEstimate = (pos-1)*gpsc.fs/length(rcF);

% to show that you know what your resolution is ...
resolution = gpsc.fs/length(rcF);
sprintf('My resolution is: %d Hz', resolution)
end