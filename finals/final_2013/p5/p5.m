clear all; close all; clc;

% load the data (code, signalTx, signalRx)
load('signals');


% sampling period (s)
Ts=1e-6;

% speed of light (m/s)
c=3*1e8;

% time interval between the two pulses (s)
tInt=1;


% determine the travel times
[R,~] = xcorr(signalRx, code);
R = R(length(signalRx):end);
[~,index1] = max(abs(R))
R(index1) = 0;
[~,index2] = max(abs(R))

% If necessary, makes the change so that index1 corresponds to first signal
% and index2 to the second signal
if index1 > index2
    tmp = index1;
    index1 = index2;
    index2 = tmp;
end

% a) The travel times are
tt1 = index1*Ts % [s]
tt2 = index2*Ts-tInt % [s]

% b) determine the distances
% 2d1 = c*tt1 so d1 = 1/2(c*tt1), same for tt2
d1 = 0.5*(c*tt1); % [m] distance at time 0+tt1
d2 = 0.5*(c*tt2); % [m]

% determine the times corresponding to these distances
t1 = tt1/2;
t2 = tInt+tt2/2;

% determine the speed
speed = (d2-d1)/(t2-t1)

%distance at t=0
distance_t0 = d1 - speed*t1
d2 - speed*t2

display('Distance in [m] at t=0 is:');
distance_t0

