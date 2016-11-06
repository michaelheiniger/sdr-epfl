
% Load signal
data = load('am_signal.mat');
s = data.am_signal;

fc = 20e3; % Hz
fs = 100e3; % Hz

% Demodulation
m_rec = my_amdemod(s, fc, fs);

% Downsampling
ds_factor = 10;
m_rec_ds = downsample(m_rec, ds_factor);

% Play recovered signal
sound(m_rec_ds, fs/ds_factor);