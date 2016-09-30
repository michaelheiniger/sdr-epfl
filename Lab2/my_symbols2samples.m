function [ Z ] = my_symbols2samples( Y, H, USF )
% MY_SYMBOLS2SAMPLES Produces the samples of the modulated signal
% Z = MY_SYMBOLS2SAMPLES(Y, H, USF) produces the samples of a
% modulated pulse train. The sampled pulse is given in vector H,
% and the symbols modulating the pulse are contained in vector Y.
% USF is the upsampling factor, i.e., the number of samples per symbol.
% It is the the ratio between the sampling frequency (Fs)
% and the symbol frequency (Fd), USF=Fs/Fd.

% Add USF-1 zeroes between each sample of Y
upsampled_samples = upsample(Y, USF);

Z = conv(upsampled_samples, H);

end

