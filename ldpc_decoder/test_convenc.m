% [UNCODED_BER, CODED_BER] = TEST_CONVENC(IMAGE_FILE, Es_sigma2)
%
% TEST_CONVENC compares the BER and 'image quality' of the transmission of 
% the image with name IMAGE_FILE over an AWGN, with and without convolutional
% coding (constraint length 4, generator polynomial [5 7]); 
% BPSK modulation is used, and Es_sigma2 is the ratio, expressed in dB, of
% the energy per symbol to noise variance at the output of the matched
% filter of the receiver (sigma2 = N0/2)
%
% The function returns the bit error rate for the uncoded scheme as first
% output, and the bit error rate for the coded scheme as second output

function [uncoded_BER, coded_BER] = test_convenc(image_file, Es_sigma2)

% Read in the image
im = imread(image_file);

% Downsample and reduce the bit-depth of the image
BPP = 6; % bits per pixel
DSF = 4; % downsampling factor
im_reduced = imgreduce(im, DSF, BPP);
[m, n] = size(im_reduced); % save the dimensions for use in the receiver

% Convert to bits
info_bits = img2bits(im_reduced,BPP);

% Uncoded transmission
[est_bits_uncoded, uncoded_BER] = transmit_bpsk(info_bits, Es_sigma2);

% Coded transmission:
[est_bits_coded, coded_BER] = transmit_coded_bpsk(info_bits, Es_sigma2);

% Convert back to images
rx_coded_im = bits2img(est_bits_coded, BPP, m, n);
rx_uncoded_im = bits2img(est_bits_uncoded, BPP, m, n);

%figure();
figure('units','normalized','position',[.5 .5 .4 .4])
subplot(1,3,1);
imshow(im_reduced, [0 2^BPP]);
title('Original Image');

subplot(1,3,2);
imshow(rx_uncoded_im, [0 2^BPP]);
title('Uncoded transmission');
xlabel(sprintf('E_s/\\sigma^2=%0.1f, BER=%0.1e', Es_sigma2, uncoded_BER));

subplot(1,3,3);
imshow(rx_coded_im, [0 2^BPP]);
title('Coded transmission');
xlabel(sprintf('E_s/\\sigma^2=%0.1f, BER=%0.1e', Es_sigma2, coded_BER));
