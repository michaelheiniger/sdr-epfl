% Determine the complete subframes from a sequence of received bits 

clear all; close all; clc;

% Load the data received from the satellite and the preamble
d = load('preamble_ex');

data = d.data;
preamble = d.preamble;

% Build mask for cross-correlation
length_subframe = 300; %bits
length_preamble = length(preamble);
mask = [preamble, zeros(1, length_subframe-length_preamble)];

% Repeat mask 5 times to make the detection more robust
mask = repmat(mask, 1, 5);

% Cross-correlation to detect begining of subframes
[R, ~] = xcorr(data, mask);
R = R(length(data):end);
[~, index] = max(abs(R));

% Remove excess bits at the beginning and at the end of the received data
data_trunc = data(index:end);
number_subframes = floor(length(data_trunc)/length_subframe);
data_trunc = data(1:length_subframe*number_subframes);

% If the preamble found in the data has inverted sign, flip all the data values.
preamble_rx = data_trunc(1:length_preamble) ;

if (preamble == -preamble_rx)
    data_trunc = -data_trunc;
end


