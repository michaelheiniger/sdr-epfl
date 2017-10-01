    % fill in your code according to the description given in the problem statement

% 4-QAM
m = 4;

% Number of bits to generate
n_bits = 1e6;

% Sample random bits (alreagy formatted for 4-QAM mapping)
bits = randi(2, ceil(n_bits/log2(m)),log2(m))-1;

% Define Gray-code 4-QAM constellation
map = [1+1i, 1-1i, -1+1i, -1-1i];

% Map bits to QAM symbols
symbols = map(bi2de(bits)+1);

length_pulse = 40; % 40T
USF = 4; % #samples per symbol
pulse = sinc(-length_pulse/2:1/USF:length_pulse/2); 

pulse = pulse / norm(pulse); % Normalize pulse

tx_signal = conv(upsample(tx_symbols,USF), pulse);
% subplot(1,2,1),plot(real(tx_signal));
% subplot(1,2,2),plot(imag(tx_signal));
rx_signal = tx_signal;

MF_output = conv(rx_signal, conj(fliplr(pulse)));
delay = length(pulse)-1;
rx_symbols = MF_output(delay+1:USF:length(MF_output)-delay);



% plot(rx_symbols,'*')

