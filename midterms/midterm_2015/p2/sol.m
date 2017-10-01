% fill in your code according to the description given in the problem statement

% parameters
no_bits = 1e6;
length_ps = 40; % length of the pulse shaping filter, in symbols
USF = 4; % upsampling factor

% generate 1e6 random bits
bits = randi([0, 1], 1, no_bits);

% map the bits into 4-QAM symbols, Gray mapping: [00, 01, 10, 11] --> [1+1i, 1-1i, -1+1i, -1-1i]
tx_symbols = [1 1i]*reshape(1-2*bits, 2, length(bits)/2);

% create the normalized pulse shape filter
h = (1/sqrt(USF))*sinc(-length_ps/2:1/USF:length_ps/2);

% visualize the filter
fvtool(h, 'impulse')

% convolve with the pulse shaping filter to generate the
% baseband-equivalent signal
tx = conv(upsample(tx_symbols,USF),h);

% add eventually some noise. Here we have no noise
rx = tx;

% matched filter
mf_output = conv(rx,conj(fliplr(h)));

% sample the matched filter output and get the symbols
rx_symbols = mf_output(length(h):USF:end-length(h)+1);

% plot the received constellation
% figure;
% plot(rx_symbols, '*')
% title('4-QAM at the output of the matched filter')
% xlabel('Real')
% ylabel('Imag')
% grid on

% The "clouds" appear due to the truncation of the sinc function.
% The support of the sinc function is infinite, but we consider only a limited
% portion of it. Thus, the truncated sinc will not be anymore
% orthogonal to its time shifts with T, which will create inter symbol
% interference (ISI). This translates into noise at the output of the
% matched filter.
% To reduce this noise we need to increase the length of the truncated sinc.
% Notice the difference with rcosdesign which can achieve a good orthogonality
% (no ISI) with a relativelly short filter compared to the sinc. There is a trade-off though:
% in the frequency domain, rcosdesign will produce a larger spectrum with smooth
% edges compared to the narrower spectrum with sharp edges of the sinc.
