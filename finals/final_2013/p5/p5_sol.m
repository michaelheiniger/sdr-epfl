% load the data (code, signalTx, signalRx)
load signals
% sampling period (s)
Ts=1e-6;
% speed of light (m/s)
c=3*1e8;
% time interval between the two pulses (s)
tInt=1; % s

% determine the travel times
c2=abs(xcorr(signalRx,code));
c2=c2(length(signalRx): end);
th=numel(code)/2;
v2=find(c2>th)

% indexing in MATLAB starts from 1!!
tt=Ts*(v2-[1, 1+round(tInt/Ts)])
% determine the distances
distances=c*tt/2;
% determine the times corresponding to these distances
times=[tt(1)/2, tInt+tt(2)/2];
% determine the speed
vEst=(distances(2)-distances(1))/(times(2)-times(1))
%distance at t=0
d0=distances(1)-vEst*times(1)