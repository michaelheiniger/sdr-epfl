function [ subframes ] = my_sol( )
%MY_SOL Summary of this function goes here
%   Detailed explanation goes here

% Determine the complete subframes from a sequence of received bits 

% Load the data received from the satellite and the preamble
d = load('preamble_ex');

data = d.data;
preamble = d.preamble;

% Build mask for cross-correlation
length_subframe = 300; %bits
length_preamble = length(preamble);
mask = [preamble, zeros(1, length_subframe-length_preamble)];

% Repeat mask as many times as possible to make the detection more robust
number_rep = floor(length(data)/length_subframe)-1; % == 5
mask = repmat(mask, 1, number_rep);

% Cross-correlation to detect begining of subframes
[R, ~] = xcorr(data, mask);
R = R(length(data):end);
[~, index] = max(abs(R));

% Remove excess bits at the beginningof the received data
data_trunc = data(index:end);

% Remove excess bits at the end of the received data
number_subframes = floor(length(data_trunc)/length_subframe);
data_trunc = data_trunc(1:length_subframe*number_subframes);

% Get one of the received preambles
preamble_rx = data_trunc(1:length_preamble) ;

% If the preamble found in the data has inverted sign, flip all the data values.
if (preamble == -preamble_rx)
    data_trunc = -data_trunc;
end

subframes = data_trunc;

end

