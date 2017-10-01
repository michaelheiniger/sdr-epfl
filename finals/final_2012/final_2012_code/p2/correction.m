function [ subframes ] = correction()
%CORRECTION Summary of this function goes here
%   Detailed explanation goes here

% Load the data received from the satellite and the preamble
load preamble_ex

lFrame = 300;
%minimum number of complete frames
Nbits=numel(data);
nFull=floor(Nbits/lFrame)-1;
preambleRep=repmat([preamble, zeros(1,lFrame-length(preamble))], 1, nFull);
pCorr=round(abs(xcorr(data, preambleRep)));

%find the start of the first frame
pCorr(1:length(data)-1)=[];
ind=find(pCorr==max(pCorr));
ind=ind(1);

%remove excess bits at the beginning
data_s=data(ind:end);

%number of complete subframes
n_sf=floor(numel(data_s)/lFrame);

%remove excess bits at the end
data_s=data_s(1:n_sf*lFrame);

%flip bits if necessary
if data_s(1:8)~=preamble
    data_s=-data_s;
end

subframes = data_s;
end

