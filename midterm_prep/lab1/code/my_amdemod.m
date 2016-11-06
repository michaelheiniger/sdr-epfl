function [ m ] = my_amdemod(s, fc, fs)
%MY_AMDEMOD demodulates the AM-modulated signal
%   [ m ] = MY_AMDEMOD(s, fc, fs)

% Absolute value of modulated signal 
s_abs = abs(s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design and apply low-pass filter (Butterworth filter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filter order
filter_order = 8;
% Cutoff frequency
cutoff = fc/2; % Why not (?) 
% cutoff/fs = fc/2fs < 1 since fc<1/2fs, so we satisfy the requirements
% of the butter function
[b, a] = butter(filter_order, cutoff/fs);

% Apply low-pass filter
s_filtered = filter(b, a, s_abs);

% Remove the mean
s_zm = s_filtered - mean(s_filtered(1:length(s_filtered)));

% Convert to be between -1 and 1
s_demod = s_zm / max(abs(s_zm(1:length(s_zm))));

m = s_demod;

end

