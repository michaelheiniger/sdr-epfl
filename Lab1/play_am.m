function play_am()
%PLAY_AM Summary of this function goes here
%   Detailed explanation goes here

fc = 20000; %Hz
fs = 100000; %Hz
downsample_factor = 10;

load('am_signal');

m = my_amdemod(am_signal, fc, fs);
% m = sol_amdemod(am_signal, fc, fs);

m_downsampled = downsample(m, downsample_factor);

% Keeps only the real value
real_downsampled_m = real(m_downsampled);

sound(real_downsampled_m, fs/downsample_factor); % Takes into account the downsampling

end

