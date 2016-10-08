% Example of design of square-root raised cosine filter (RRC)

clear all;
close all;
%% Parameters
Fd = 1;      % symbol rate
USF = 10;     % upsampling factor (number of samples per symbol)
Fs = USF*Fd; % sampling frequency

% We need to truncate the infinite impulse response of the RRC filter 
% to approximate it by a FIR filter
delay = 10;  % in number of symbol periods 
			 % ( = number of lobes of the time response at each side of the main one that we keep).

beta = 0.5; % roll-off factor 
% change this to 0, 0.5 and 1.0 (for instance) and observe the effect on
% both the impulse and frequency response

%% Filter design


order = 2*USF*delay; % Default delay is order/2 (to have the peak centered,
% so we take order/2 coeff to the left and right of the peak)
% Order of the polynomial, must be even; the length of the filter is order+1
h = firrcos(order, Fd/2, beta, Fs, 'rolloff', 'sqrt');
% The second parameter is the cut-off frequency
% Equivalently, we could have used the function 'rcosine' to design the filter:
	 %h = rcosine(Fd, Fs, 'sqrt/fir', beta, delay); % here the filter is already normalized to norm 1
% Or as Matlab recommends:
    %h = rcosdesign(beta, 2*delay, Fs, 'sqrt'); % here the filter is already normalized to norm 1
    fvtool(h, 'Analysis', 'impulse')   % Visualize the filter

%% Results

% h is normalized to have nominal gain of 1 in the passband

% frequency response
figure;
NFFT = 2^nextpow2(length(h));
f = linspace(-Fs/2, Fs/2-Fs/NFFT, NFFT);hold on;
plot(f, abs(fftshift(fft(h, NFFT))), 'r'); 
plot(f, abs(fftshift(fft(h/norm(h), NFFT))), 'b'); 
grid on;
xlabel('f [Hz]'); ylabel('|H(f)|'); 
legend( 'firrcos', 'normalized to norm 1');
title(sprintf('roll-off factor \\beta=%1.2f', beta));


%impulse response
figure;
t = (-delay*USF:1:delay*USF)*1/Fs;
plot(t, h, 'r');hold on;
plot(t, h/norm(h), 'b');
grid on;
xlabel('t [s]'); ylabel('h(t)'); legend('firrcos', 'normalized to norm 1');
title(sprintf('roll-off factor \\beta=%1.2f', beta));
