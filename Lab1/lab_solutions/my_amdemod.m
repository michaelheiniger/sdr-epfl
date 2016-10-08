% MY_AMDEMOD Demodulate AM signal
%    M = MY_AMDEMOD(S, FC, FS) is the demodulation of an AM (amplitude
%    modulation) signal at carrier frequency FC, sampled at FS. The
%    returned signal is normalized to have values between -1 and 1.

function s_demod = my_amdemod(s, fc, fs)
    N_ORDER = 2; % 8 for a better filtering, the demodulated signal will look better
    CUTOFF = fc/2; % a good choice for audio will be 16000
    
    % Take absolute value
    s_abs = abs(s);
    
    % Filter with butterworth filter at half the center frequency
    [b, a] = butter(N_ORDER, 2 * CUTOFF / fs);   % cf help butter
    s_filt = filter(b, a, s_abs);
    
    % Remove the mean %(eventually ignore the 100 first elements to remove the transients from the filter)
    s_zm = s_filt - mean(s_filt(1:length(s_filt)));
    
    % Convert to be between -1 and 1 %( eventually ignore the 100 first elements)
    s_demod = s_zm / max(abs(s_zm(1:length(s_zm))));
end
