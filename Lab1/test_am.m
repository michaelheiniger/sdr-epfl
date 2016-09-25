function test_am()
%PLAY_DM Summary of this function goes here
%   Detailed explanation goes here

f_info = 10; % Hz
fc = 300; % Hz
fs = 4000; % Hz
A = 1; % Amplitude
K = 1; % ??
d = 1; % second

% Time vector
t = linspace(0, d, d*fs);

% Message signal (to be modulated)
m = 0.5*cos(2*pi*f_info*t);

% Plot original signal
% tfplot(m, fs, 'm', 'Original signal');
% pause;

% Plot absolute value of signal
% tfplot(abs(m), fs, 'abs(m)', 'Absolute value of signal');
% pause;

% AM-modulate the signal s
s = my_ammod(m, K, A, fc, fs);
% s = sol_ammod(m, K, A, fc, fs);


% tfplot(abs(s), fs, 'abs(s)', 'Absolute value of modulated signal');
% pause;

% Plot AM-modulated signal
% tfplot(s, fs, 's', 'Modulated signal');
% pause;

m_recovered = my_amdemod(s, fc, fs);
% m_recovered = sol_amdemod(s, fc, fs);
tfplot(m_recovered, fs, 'mdemod', 'Demodulated signal');


end

