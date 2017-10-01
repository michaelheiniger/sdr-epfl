% Rotating constellation

clear all; close all; clc;

load data

% plot the received data
figure(1);
plot(received,'*');
xlabel('Real');
ylabel('Imag');
title('Received symbols');
grid on;

l = length(preamble);

% get the received preamble
rPreamble = received(1:l);

% compute the rotations over the preamble
rotations = rPreamble.*conj(preamble)

% plot the rotations, to see if they increase linearly
figure(2);
plot(angle(rotations),'*');
xlabel('Symbol index');
ylabel('Angle (radians)');
grid on;

% compute the rotation step
differences = diff(angle(rotations));
averageIncrement = mean(differences);

% compensation sequence
compensations = exp(-1i*averageIncrement*[0:length(received)-1]);

% compensate for the rotations
rx_data_corrected = received.*compensations;

% plot the corrected symbols
figure(3);
plot(rx_data_corrected,'*');
xlabel('Real');
ylabel('Imag');
title('Received symbols corrected');
grid on;