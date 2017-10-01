clear;
clc;

load('data');


% a)
% The rotation is due to a difference in the sampling rate of the Tx and Rx
% receiver: the phase difference increases linearly with time
% plot(received, '*');


% b)
% plot(preamble,'*');
preamble_rx = received(1:length(preamble));
phase_diff_s1 = phase(preamble_rx(1))-phase(preamble(1));
phase_diff_sl = phase(preamble_rx(end))-phase(preamble(end));

diff_samples = length(preamble)-1;

% Phase rate: how much the phase change per sample
phase_rate = (phase_diff_sl-phase_diff_s1)/diff_samples; % rad/sample

% sample line
s = (0:length(received)-1);
phase_line = phase_rate * s;

% Remove extra phase
received_corrected = received .* exp(-j*phase_line);

subplot(2,1,1),plot(received,'*');
subplot(2,1,2),plot(received_corrected,'*');
