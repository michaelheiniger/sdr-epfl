
Es_sigma2 = 10; % Db

image_file= 'elaine.512.tiff';

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

% ConvEnc Coded transmission:
[est_bits_convenc_coded, convenc_coded_BER] = transmit_convenc_coded_bpsk(info_bits, Es_sigma2);

% LDPC Coded transmission:
[est_bits_ldpc_coded, ldpc_coded_BER] = transmit_ldpc_coded_bpsk(info_bits, Es_sigma2);

% Convert back to images
rx_ldpc_coded_im = bits2img(est_bits_ldpc_coded, BPP, m, n);
rx_convenc_coded_im = bits2img(est_bits_convenc_coded, BPP, m, n);
rx_uncoded_im = bits2img(est_bits_uncoded, BPP, m, n);

%figure();
figure('units','normalized','position',[.5 .5 .4 .4])
subplot(1,4,1);
imshow(im_reduced, [0 2^BPP]);
title('Original Image');

subplot(1,4,2);
imshow(rx_uncoded_im, [0 2^BPP]);
title('Uncoded transmission');
xlabel(sprintf('E_s/\\sigma^2=%0.1f, BER=%0.1e', Es_sigma2, uncoded_BER));

subplot(1,4,3);
imshow(rx_convenc_coded_im, [0 2^BPP]);
title('Convenc Coded transmission');
xlabel(sprintf('E_s/\\sigma^2=%0.1f, BER=%0.1e', Es_sigma2, convenc_coded_BER));

subplot(1,4,4);
imshow(rx_ldpc_coded_im, [0 2^BPP]);
title('LDPC Coded transmission');
xlabel(sprintf('E_s/\\sigma^2=%0.1f, BER=%0.1e', Es_sigma2, ldpc_coded_BER));

