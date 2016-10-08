function tfplot(s, fs, name, plottitle)
% TFPLOT Time and frequency plot
%    TFPLOT(S, FS, NAME, PLOTTITLE) displays a figure window with two subplots.
%    Above, the signal S is plotted in time domain, with the x-axis
%    labeled in seconds. The sampling frequency is FS.
%    Below, the absolute value of the signal in the frequency domain, with the
%    x-axis labeled in Hz. NAME is the "name" of the signal, e.g., if NAME is
%    's', then the labels on the y-axes will be 's(t)' and '|s_F(f)|',
%    respectively.  TITLE is the title that will appear above the two plots.

s_length = length(s);

% Data for first plot

% Time vector
% linspace(start point, end point, #samples)
% Starts at 0, so need to remove one to get end point
t = linspace(0, (s_length-1)/fs, s_length);

% Data for second plot
S = fft(s,s_length); % the fft resulting vector is padded with zeros
S_mag = abs(S);

% Center the 0 Hz freq
shifted_fft = fftshift(S_mag);

% Frequency vector
% Need to remove fs/s_length to get end point because of 0
f = linspace(-fs/2, fs/2-fs/s_length, s_length);

%Actual plotting
figure1 = figure;
set(figure1, 'Position', [500 500 1000 1000]);
title(plottitle);
subplot(2,1,1), stem(t, s, 'Marker', '.');
xlabel('t [s]');
ylabel([name '(t)']);
subplot(2,1,2), stem(f, shifted_fft, 'Marker', '.');
xlabel('f [Hz]');
ylabel(['|' name '_F(f)|']);

end

