% Sampling

clear all; close all; clc;

no_new_samples = 1024;
% original sampling time
Ts1 = 1e-6;

% load the samples
aux = load('samples.mat');
samples_read = aux.samples;

% original time line
t_orig = 0:length(samples_read)-1;

% new sampling time
Ts2 = Ts1*(length(samples_read)-1)/(no_new_samples-1);

% new time line: t_new = linspace(t_orig(1), t_orig(end), no_new_samples);
t_new = linspace(0, length(samples_read)-1, no_new_samples) % it is of the form k*Ts2/Ts1, k = 0 to no_new_samples-1

% sampling theorem: s(t) = sum_n s(n*Ts1)*sinc(t/Ts1 - n)
% we want the samples at t = k*Ts2, so: s(k*Ts2) = sum_n s(n*Ts1)*sinc(k*Ts2/Ts1 - n)

% we generate a matrix of time indices with k being the index of the rows
% and n being the index of the columns. A multiplication of sinc(matrix_of_time_indices)
% to the right with the column vector s(n*Ts1) (the original samples) will produce the new samples

% ndgrid is producing the matrix that we need: note that t_new corresponds to k*Ts2/Ts1
% and t_orig to n (with respect to the formula of the sampling theorem above)
[t1, t2] = ndgrid(t_new, t_orig);

% create the new samples
new_samples = sinc(t1-t2)*samples_read.';

% plot the signal 
figure;
plot(t_orig*Ts1, samples_read, 'o', t_new*Ts1, new_samples)
xlabel('Time [s]'); ylabel(sprintf('%s(t)', 's'));
title('A random signal');
legend('Original samples','New samples','Location','SouthWest')
legend boxoff
grid on