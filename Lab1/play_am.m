function play_am()
%PLAY_AM Summary of this function goes here
%   Detailed explanation goes here

fc = 20000; %Hz
fs = 100000; %Hz
downsample_factor = 10;

load('am_signal');

% Demodulate the AM-modulated signal
m = my_amdemod(am_signal, fc, fs);
% m = sol_amdemod(am_signal, fc, fs);

% Downsample the demodulated signal
m_downsampled = downsample(m, downsample_factor);

% Plot the downsampled demodulated signal
tfplot(m_downsampled, fs, 'mdemod', 'Demodulated signal');

% Keeps only the real value
real_downsampled_m = real(m_downsampled);

% Play the demodulated signal
% Note: the downsampling is taken into account by the division
sound(real_downsampled_m, fs/downsample_factor); 

end

