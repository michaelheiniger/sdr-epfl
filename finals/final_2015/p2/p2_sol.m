% Sampling

clear all; close all; clc;

no_new_samples = 1024;
% original sampling time
Ts = 1e-6;

% load the samples
aux = load('samples.mat');
samples_read = aux.samples;
é
% original time line
t_orig = 0:length(samples_read)-1;


% new sampling time
Ts1 = Ts*(length(samples_read)-1)/(no_new_samples-1);

% new time line: t_new = linspace(t_orig(1), t_orig(end), no_new_samples);
t_new = linspace(0, length(samples_read)-1, no_new_samples) % it is of the form k*Ts1/Ts, k = 0 to no_new_samples-1

% sampling theorem: s(t) = sum_n s(n*Ts)*sinc(t/Ts - n)
% we want the samples at t = k*Ts1, so: s(k*Ts1) = sum_n s(n*Ts)*sinc(k*Ts1/Ts - n)

% we generate a matrix of time indices with k being the index of the rows
% and n being the index of the columns. A multiplication of sinc(matrix_of_time_indices)
% to the right with the column vector s(n*Ts) (the original samples) will produce the new samples

% ndgrid is producing the matrix that we need: note that t_new corresponds to k*Ts1/Ts
% and t_orig to n (with respect to the formula of the sampling theorem above)
[t1, t2] = ndgrid(t_new, t_orig);

% create the new samples
new_samples = sinc(t1-t2)*samples_read.';

% plot the signal 
% figure;
% plot(t_orig*Ts, samples_read, 'o', t_new*Ts, new_samples)
% xlabel('Time [s]'); ylabel(sprintf('%s(t)', 's'));
% title('A random signal');
% legend('Original samples','New samples','Location','SouthWest')
% legend boxoff
% grid on