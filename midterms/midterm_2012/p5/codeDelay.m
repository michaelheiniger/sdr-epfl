% Load data.mat. 
% Knowing that satellite 9 has Doppler frequency 1030 Hz,
% find the first sample that contains the start of the C/A code of satellite 9. 

clear; close all; clc;

%load the GPS parameters
gpsConfig();
global gpsc;

sat_number=9;
doppler=1030;

%load the data (you do not need to use the getData instruction)
load data;

%use the satCode() function to obtain the C/A code of the satellite
ca_code = satCode(sat_number, 'fs');
ca_repeat = ca_code; %repmat(ca_code, 1, 1);

%determine the sample from which the first code starts

% Load data
data1 = data(1:2*(length(ca_repeat))-1);
% data1 = samples(1:length(ca_repeat));
% data2 = samples(length(ca_repeat):end);

% Time axis
t = (0:length(data1)-1)*gpsc.Ts;

length(t)
length(data1)
% length(data2)
% Correct Doppler (remove it)
data1_dc = data1.*exp(-1j*2*pi*doppler*t);
% data2_dc = data2.*exp(-1j*2*pi*doppler*t);

[R1, ~] = xcorr(data1_dc, ca_repeat);
R1 = R1(length(data1_dc):end);
% R1 = R1(1:length(ca_repeat));
[max_corr1, tau1] = max(abs(R1));

% [R2, ~] = xcorr(data2_dc, ca_repeat);
% R2 = R2(length(data2_dc):end);
% R2 = R2(1:length(ca_repeat));
% [max_corr2, tau2] = max(abs(R2));

tau_est = tau1;

% if max_corr1 < max_corr2
%    tau_est = tau2; 
% end

% tau_est =  mod(tau_est, gpsc.spc);

% Sample index from which the first code starts is
tau_est








 
