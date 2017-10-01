
clc; clearvars; clear all;

% Load the signal
load samples.mat;

% Variables
Ts = 1e-6;

s1 = samples;
signal_duration = length(s1)*Ts;
length_s2 = 1024;
Ts2 = signal_duration / length_s2;

% Old sampling times
sampling_times_old = (0:length(samples) - 1);

% Generate a vector of sampling times for 1024 equally spaced samples
% within the time interval where the signal is defined
sampling_times_new = linspace(0, length(samples) - 1, 1024)'

% Sampling times rep
sampling_times_new_rep = repmat(sampling_times_new, 1, length(samples));

% Old sampling times rep
sampling_times_old_rep = repmat(sampling_times_old, 1024, 1);

% Create H matrix
H = sinc(sampling_times_new_rep - sampling_times_old_rep);
size(H)

% Resample the signal
resampled = H * samples';

plot(sampling_times_old*Ts, samples, 'o', sampling_times_new*Ts, resampled);