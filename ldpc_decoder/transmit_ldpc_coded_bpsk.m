function [s_est, BER] = transmit_ldpc_coded_bpsk( s, Es_sigma2 )
%TRANSMIT_LDPC_CODED_BPSK Summary of this function goes here
%   Detailed explanation goes here

aux = load('Hsparse.mat');

H = my_makeh(aux.Hsparse); %  generate sparse parity check matrix

% Length of the message to send
message_length = length(s);

% Number of bits that can be sent per channel use
bits_per_channel_use = size(H,2)-size(H,1);

% Total number of bits sent (original message + padding)
total_length_padded = ceil(message_length/bits_per_channel_use)*bits_per_channel_use;

% Length of the padding
padding_length = total_length_padded - message_length;

% Add padding to send a multiple of the number of bits per channel use
s = [s, zeros(1, padding_length)];

s_est = zeros(1, total_length_padded);

for i = 1:bits_per_channel_use:total_length_padded
    cw = my_ldpcencoder(s(i:i+bits_per_channel_use-1), H); % do the encoding

    tx_sym = 1-2*cw;

    rx_sym = awgn(tx_sym, Es_sigma2, 'measured'); 

    llr0 = rx_sym;
    numiter = 1000;

    llrout = sol_ldpcdecoder(llr0, numiter, H);

    size(llrout) %%%% = 5000 !?cd
    s_est(i:i+bits_per_channel_use-1) = (llrout > 0); 

BER = sum(s ~= s_est)/length(s);

end

