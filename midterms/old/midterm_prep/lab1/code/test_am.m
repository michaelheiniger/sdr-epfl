
% Parameters:
f_info = 10; %Hz
fc = 300; % Hz
A = 1;
K = 1;
fs = 4000; % Hz

% Duration of the signal
duration = 1; % seconds

% Time axis of the signal
t = linspace(0, duration-1/fs, duration*fs);

% Signal to modulate
m = 0.5*cos(2*pi*f_info*t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modulates the signal
s = my_ammod(m, K, A, fc, fs);
% s = sol_ammod(m, K, A, fc, fs);

% Plot the original signal
tfplot(m, fs, 'm', 'Original signal');
pause;

% Plot the modulated signal
tfplot(s, fs, 's', 'Modulated signal');
pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demodulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demodulates the signal
s_demod = my_amdemod(s, fc, fs);
% s_demod = sol_amdemod(s, fc, fs);

% Plot the demodulated signal
tfplot(s_demod, fs, 'm_recovered', 'Demodulated signal');
pause;







