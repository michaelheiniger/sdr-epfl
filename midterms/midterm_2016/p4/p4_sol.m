load('d.mat'); % 10000 symbols
load('p.mat'); % 1023 symbols
load('r.mat'); % 32796 symbols

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract first QAM sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load twice the length of preabmle + one length of QAM seq. -1 in order to have a full
% one. This makes it more efficient since we don't have to process the
% whole r data.
length_qam_seq = 1e4;
% -1 to not have exactly 2 preambles
data = r(1:2*length(p)+length_qam_seq-1);

% Find the first preamble using cross-correlation
[R, ~] = xcorr(data, p);

% Remove the zero-padding and rampup
R = R(length(data):end);

% find the maximum of the correlation and its index tau
[max_R, tau] = max(abs(R))

% Extract the QAM sequence following the first preamble found 
first_qam_seq = r(tau+length(p):tau+length(p)+length_qam_seq-1);

% Make it a column-vector
first_qam_seq = transpose(first_qam_seq);

% Nicolae
length(first_qam_seq)
figure;
plot(first_qam_seq,'*'); grid on;

% Plot the found QAM sequence
%plot(first_qam_seq);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Decode QAM sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4-QAM constellation
map = [ -1 + 1i, -1 - 1i, 1 + 1i, 1 - 1i];

% Demodulates 4-QAM symbols
% Since the channel is assumed to be AWGN, the ML detector is minimum distance
qam_seq_rep = repmat(first_qam_seq, 1, length(map));
map_rep = repmat(map, length_qam_seq, 1);

% Compute min distance
[~, symbols_dec] = min(abs(qam_seq_rep - map_rep), [], 2);

% Transform into 4-QAM symbols
decoded_qam_seq = map(symbols_dec);

% Compute SER
ser = sum(decoded_qam_seq ~= d)/length(decoded_qam_seq) % == 0


% Nicolae
% 9/9
% Very nice work!


