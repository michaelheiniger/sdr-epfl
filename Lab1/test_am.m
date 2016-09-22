function test_am()
%PLAY_DM Summary of this function goes here
%   Detailed explanation goes here

f_info = 10; % Hz
fc = 300; % Hz
fs = 4000; % Hz
A = 1; % Amplitude
K = 1; % ??
d = 1; % second

% t = 0:1/fs:d;
t = linspace(0, d, d*fs + 1);

% Original signal (to be modulated)
m = 0.5*cos(2*pi*f_info*t);

% Plot original signal
tfplot(m, fs, [' 0.5*cos(2*pi*' f_info '*t)'], 'Original signal');
pause;

% AM-modulate the signal s
s = my_ammod(m, K, A, fc, fs);

% Plot AM-modulated signal
tfplot(s, fs, '', 'Modulated signal');
pause;
m_recovered = my_amdemod(s, fc, fs);

tfplot(m_recovered, fs, '', 'Demodulated signal');


end

