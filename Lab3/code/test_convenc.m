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

%(c) Conversion to bits for transmission
image_reduced_bits = img2bits(image_reduced, B);

%(d) Transmission, uncoded and coded over AWGN channel
[S_EST_uncoded, UNCODED_BER] = transmit_bpsk(image_reduced_bits, Es_sigma2);
[S_EST_coded, CODED_BER] = transmit_coded_bpsk(image_reduced_bits, Es_sigma2);

%(e) Display original (although reduced) and transmitted images (with
% uncoded and coded schemes)
figure('Position', [100, 100, 1200, 500]);
subplot(1,3,1),imshow(image_reduced);
title('Original (reduced)');
subplot(1,3,2),imshow(bits2img(S_EST_uncoded, B, img_width, img_height));
title('Transmitted over AWGN - uncoded');
subplot(1,3,3),imshow(bits2img(S_EST_coded, B, img_width, img_height));
title('Transmitted over AWGN - conv. coded');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: Based on the resulting BERs (uncoded is better than coded), it
% seems that there is some mistake somewhere. I'm not sure that it is in
% the convolutional encoding/decoding process. I'm rather thinking about
% the BPSK MAP. Indeed, even though it gives me satisfying results
% when testing, the plot created by err_rates_coded_uncoded varies for the
% experimental coded graph when using my implementation of QPSK and the one
% given as solution. When testing only the MAPs, the output is
% essentially the same, except for some weird (to me) data format
% difference. I tried to cast the output of my MAP as complex but it
% did not solve the difference. It actually drives me crazy because the
% simple fact the use one rather than the other makes the empirical coded 
% BER better or worse than the  theoretical: it makes no sense to me :/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

