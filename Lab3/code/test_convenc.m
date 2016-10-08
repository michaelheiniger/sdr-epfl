function [UNCODED_BER, CODED_BER] = test_convenc( IMAGE_FILE, Es_sigma2 )
% [UNCODED_BER, CODED_BER] = TEST_CONVENC(IMAGE_FILE, Es_sigma2)
% TEST_CONVENC compares the BER and quality of the transmission
% of image IMAGE_FILE over the AWGN with and without convolutional
% coding. The code used has octal generators [5 7].
% BPSK modulation is used for the transmission.
% Es_sigma2 specifies, in dB, the ratio of the energy per symbol
% to noise variance at the output of the matched filter of the
% receiver.
% The function returns the bit error rate for the uncoded scheme
% as first output, and the bit error rate for the coded scheme
% as second output

%(a)
image = imread(IMAGE_FILE);

%(b)
G = 4;
B = 6;
image_reduced = imgreduce(image, G, B);
img_width = size(image_reduced,1);
img_height = size(image_reduced,2);

%(c)
image_reduced_bits = img2bits(image_reduced, B);

%(d)
Es_sigma2 = 1/1000;
[S_EST_uncoded, UNCODED_BER] = transmit_bpsk(image_reduced_bits, Es_sigma2);
[S_EST_coded, CODED_BER] = transmit_coded_bpsk(image_reduced_bits, Es_sigma2);

%(e)
subplot(1,3,1),imshow(image_reduced);
subplot(1,3,2),imshow(bits2img(S_EST_uncoded, B, img_width, img_height));
subplot(1,3,3),imshow(bits2img(S_EST_coded, B, img_width, img_height));

UNCODED_BER
CODED_BER

end

