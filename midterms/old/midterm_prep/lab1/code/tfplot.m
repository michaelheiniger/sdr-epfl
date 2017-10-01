% TFPLOT Time and frequency plot
%    TFPLOT(S, FS, NAME, PLOTTITLE) displays a figure window with two subplots.
%    Above, the signal S is plotted in time domain, with the x-axis
%    labeled in seconds. The sampling frequency is FS.
%    Below, the absolute value of the signal in the frequency domain, with the
%    x-axis labeled in Hz. NAME is the "name" of the signal, e.g., if NAME is
%    's', then the labels on the y-axes will be 's(t)' and '|s_F(f)|',
%    respectively.  TITLE is the title that will appear above the two plots.
function tfplot(s, fs, name, plot_title)

length_s = length(s);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Represent signal s in time domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time axis used to represent s in time domain
t = linspace(0, (length_s-1)/fs, length_s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Represent magnitude of signal s in frequency domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DFT of signal s: here we use every sample of s to compute the FFT
% rounded to next power of 2 (FFT is more efficient then)
NFFT = 2^nextpow2(length_s); 
s_f = fft(s, NFFT);

% Shift the FFT to make 0 the center frequency
shifted_s_f = fftshift(s_f);

% Magnitude of s in frequency domain
s_f_mag = abs(shifted_s_f);

% The highest frequency that can be represented using fs is fs/2 
% due to sampling theorem. Remove fs/NFFT to account for the 0.
f = linspace(-fs/2, fs/2 - fs/NFFT, NFFT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot signal s in time domain and magnitude of s in frequency domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,1,1), stem(t, s, '.');
xlabel('t [s]');
ylabel([name '(t)']);
title(plot_title);
subplot(2,1,2), stem(f, s_f_mag, '.');
xlabel('f [Hz]');
ylabel(['|' name '_{F}(f)|']);

end

