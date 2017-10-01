

%%%%%%% V1 %%%%%%

% clear;
% clc;
% 
% load('samples');
% 
% 
% % Original signal, sampled at Ts1
% Ts1 = 1e-6;
% s1 = samples;
% signal_duration = length(s1)*Ts1;
% length_s2 = 1024;
% Ts2 = signal_duration / length_s2;
% 
% % a)
% t1 = 0:length(s1)-1;
% t2 = linspace(0, length(s1)-1, length_s2);
% 
% % b)
% [i, j] = meshgrid(1:length(t1), 1:length(t2));
% 
% H = sinc(t2(j)-t1(i));
% 
% s2 = s1*transpose(H);
% 
% plot(t1*Ts2, s1, 'o',t2*Ts2, s2);



%%%%%%% V2 %%%%%%

clear;
clc;

load('samples');

% Original signal, sampled at Ts1
Ts1 = 1e-6;
s1 = samples;
signal_duration = length(s1)*Ts1;
length_s2 = 1024;
Ts2 = signal_duration / length_s2;

% a)
t1 = 0:length(s1)-1;
k = (0:length_s2-1);
t2 = Ts2/Ts1*k;

% b)
[i, j] = meshgrid(1:length(t1), 1:length(t2));

s2 = s1*transpose(sinc(t2(j)-t1(i)));

plot(t1*Ts2, s1, 'o',t2*Ts2, s2);





