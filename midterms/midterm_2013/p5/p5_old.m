% SDR 2013 midterm - Problem 5 

clear; close all; clc;

%the number of transmitted symbols (not including the training sequence)
nSymbols=1000;

% load the training sequence, named training
load training; 

%load the received signal containing the delay, the training symbols and
%the modulation symbols
load received

% (a) estimate the start of the QAM symbol sequence in the received data and the rotation
phi = -2*pi:0.01:2*pi;

best_phi = 0;
best_tau = 0;
max_corr = 0;
for k = 1:length(phi)
    
    % Correct for rotation
    received_corrected = received.*exp(-1j*phi(k));
    [R, ~] = xcorr(real(received_corrected), training);
    R = R(length(received_corrected):end);
    [corr, tau] = max(abs(R));
    
    if corr > max_corr 
       max_corr = corr;
       best_phi = phi(k);
       best_tau = tau;
    end
end
 
% Correct for rotation
received_rot_corrected = received.*exp(-1j*best_phi);

% Correct for delay by trimming the received signal
received_full_corrected = received_rot_corrected(tau:tau+nSymbols+length(training)-1);
received_delay_corrected = received(tau:tau+nSymbols+length(training)-1);

% Extract and remove the training
training_rx = received_full_corrected(1:length(training));
symbols_full_corrected = received_full_corrected(length(training)+1:end);
symbols_delay_corrected = received_delay_corrected(length(training)+1:end);

subplot(1,3,1),plot(symbols_delay_corrected,'.')
subplot(1,3,2),plot(symbols_full_corrected,'.')
subplot(1,3,3),plot(training_rx,'.')

% Demodulation of the 4-QAM symbols

% Make a column-vector
y = symbols_full_corrected(:);

MAP = [-1+1i,-1-1i, 1+1i, 1-1i];

repy = repmat(y, 1, length(MAP));
repmap = repmat(MAP, length(y), 1);

distances = abs(repy-repmap);

[~, indices] = min(distances,[], 2);

symbols_dec = indices-1;

bits_dec = de2bi(symbols_dec, 'left-msb');

bitsR_dec = transpose(bits_dec(:,1));
bitsR_dec(bitsR_dec == 0) = -1; 
bitsI_dec = transpose(bits_dec(:,2));
bitsI_dec(bitsI_dec == 1) = -1;
bitsI_dec(bitsI_dec == 0) = 1;

load('bitsR.mat');
load('bitsI.mat');

sum(bitsR_dec ~= bitsR)
sum(bitsI_dec ~= bitsI)

    


%% (b) pull out the noisy symbol sequence and correct for the phase rotation

....
    

%% (c) plot the complex plane noisy symbols

....
    

%% (d) decode the bit sequence

....

% you can compare the result with the bit sequences stored in bitsR.mat
% and bitsI.mat

%load bitsR
%load bitsI










