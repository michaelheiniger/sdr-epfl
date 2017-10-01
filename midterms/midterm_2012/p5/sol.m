clear all;
close all;
clc;
%load GPS parameters
gpsConfig();
global gpsc;
sat_number=9;
doppler=1030;
%load the data (you do not need to use the getData instruction)
load data;
%determine the sample from which the first code starts

% get C/A code for this sat and upsample it to the sampling rate
p = kron(satCode(sat_number), ones(1, gpsc.spch));

% Read a chunk of data: we need twice the length of the C/A code, minus one sample
samples_per_code = length(p);
y = data(1:2*samples_per_code-1);

% generate the time axis
t = (0 : length(y)-1) * gpsc.Ts;

correction=exp(-2*pi*1j*t*doppler);

yc=y.*correction;

c=xcorr(yc,p);

c=c(length(yc):end);

[m,tau]=max(abs(c))


