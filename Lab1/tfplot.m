function tfplot(s, fs, name, plottitle)
% TFPLOT Time and frequency plot
%    TFPLOT(S, FS, NAME, PLOTTITLE) displays a figure window with two subplots.
%    Above, the signal S is plotted in time domain, with the x-axis
%    labeled in seconds. The sampling frequency is FS.
%    Below, the absolute value of the signal in the frequency domain, with the
%    x-axis labeled in Hz. NAME is the "name" of the signal, e.g., if NAME is
%    's', then the labels on the y-axes will be 's(t)' and '|s_F(f)|',
%    respectively.  TITLE is the title that will appear above the two plots.

%data for first plot
% time = 0:1/fs:(length(s)-1)/fs;

time = linspace(0, (length(s)-1)/fs, length(s));

% Data dor second plot
S = fft(s,length(s)); % the fft resulting vector is padded with zeros
S_mag = abs(S);
freq = -fs/2:fs/(length(s)-1):fs/2;

figure1 = figure(1);
set(figure1, 'Position', [500 500 1000 1000])
subplot(2,1,1), stem(time, s, 'Marker', '.');
xlabel('t [s]');
ylabel([name '(t)']);
title(plottitle);
subplot(2,1,2), stem(freq, fftshift(S_mag), 'Marker', '.');
xlabel('f [Hz]');
ylabel(['|' name '(t)|']);

end

