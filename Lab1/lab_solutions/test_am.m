function test_am()
% Tests the AM modulator and demodulator with an audible signal.

% Alternative values are given (commented) for playing a more audible signal (440Hz)

% Define signal parameters

Finfo  = 10;     % 440;  % Message signal frequency [Hz]
Fc     = 300;    % 40e3; % Carrier frequency [Hz]
A      = 1;      % Modulation constant
K      = 1;      % Modulation constant
Fs     = 4000;   % 1000e3; % Sampling frequency [Hz]
d      = 1;      % Signal duration [s]
DownSample = 1; % 30

% Time vector
t = linspace(0,d,d*Fs+1);
display_indice = 1:d*Fs+1; 
%display_indice = (100:d*Fs/100)+1; % to display another range for the audible signal

% Create the message signal and its modulated signal
m = 0.5 * cos(2*pi*Finfo*t);
s = my_ammod(m, K, A, Fc, Fs);

% Plot both the modulated and the demodulated signal
tfplot(m(display_indice), Fs, 'm_{am}', 'Message signal');
tfplot(s(display_indice), Fs, 's_{am}', 'AM modulated signal');

% Decode the signal and plot again
m_est = my_amdemod(s, Fc, Fs);
tfplot(m_est(display_indice), Fs, 'm_{am} (est)', 'Recovered message signal');

% Play the signals and display status messages
fprintf('Playing original signal\n');
sound(downsample(m, DownSample), Fs/DownSample);
fprintf('Playing recovered signal\n');
sound(downsample(m_est, DownSample), Fs/DownSample);

end
