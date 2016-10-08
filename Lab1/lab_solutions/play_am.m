function play_am()
% This script demodulates and plays the AM signal stored in am_signal.mat.

% Signal parameters and downsampling factors
F_SAMPLE = 100e3;
F_CENTER = 20e3;
DOWNSAMPLE = 10;

% Load the samples vector from file
a = load('am_signal.mat');
radio_signal = a.am_signal;

% Demodulate and play
sdm = my_amdemod(radio_signal, F_CENTER, F_SAMPLE);
sound(downsample(sdm, DOWNSAMPLE), F_SAMPLE / DOWNSAMPLE);

end
