% COARSE_ESTIMATE Find coarse estimates of Doppler shift and delay in a GPS
% signal
% [DOPPLER_ESTIM,TAU_ESTIM,IP_RESULT]=COARSE_ESTIMATE(SAT_NUMBER,DOPPLER_STEP)
% Estimation is done correlating multiple repetitions (10 in our case) of
% the C/A code for satellite SAT_NUMBER with the received signal (to be
% read from disk using function GETDATA) 
% DOPPLER_STEP, specified in Hz, sets the resolution of the search grid 
% for Doppler estimation. The
% absolute Doppler search range to be considered is obtained from the field
% 'dopplermax' of the global struct variable 'gpsc'.
% Return value DOPPLER_ESTIM is the estimation of the Doppler shift
% (fc*nu);
% TAU_ESTIM, in number of samples, specifies where the first C/A code
% starts in the received signal (TAU_ESTIM should be an integer smaller
% than gpsc.chpc*gpsc.spch)
% IP_RESULT is the absolute value of the inner product between the
% appropriately shifted version of multiple repetitions (10) of the C/A code
% for satellite SAT_NUMBER and the Doppler corrected received signal.
% (In FINDSATELLITES() the satellites will be ordered according to the
% strength of their IP_RESULT)

function [doppler_estim, tau_estim, ip_result] = my_coarseEstimate(sat_number, doppler_step)

global gpsc;

ca_seq = satCode(sat_number, 'fs');
ca_seq = repmat(ca_seq, 1, 10);

samples = getData(1, 2*length(ca_seq));

first_10_ca = samples(1:length(ca_seq));
next_10_ca = samples(length(ca_seq)+1:end);

fs = gpsc.fs;

best_tau = 0;
t = 0:1/fs:(length(samples)/2-1)/fs;
doppler_shift = -gpsc.maxdoppler/2:doppler_step:gpsc.maxdoppler/2;

best_doppler_shift = 0;
best_correlation = 0;

for k = doppler_shift
    shifted_first_10_ca = exp(-1j*2*pi*k*t).*first_10_ca;
    shifted_next_10_ca = exp(-1j*2*pi*k*t).*next_10_ca;
        
    [correlation_first, lags_first] = xcorr(shifted_first_10_ca, ca_seq);
    [max_corr_first, index_max_first] = max(abs(correlation_first));
    
    [correlation_next, lags_next] = xcorr(shifted_next_10_ca, ca_seq);
    [max_corr_next, index_max_next] = max(abs(correlation_next));
    
    if max_corr_first > max_corr_next % bit transition occurs in next 10 CA
        tau_est = mod(lags_first(index_max_first), gpsc.spch*gpsc.chpc);
        if max_corr_first > best_correlation
            best_doppler_shift = k;
            best_tau = tau_est;
            best_correlation = max_corr_first;
        end
    else % bit transition occurs in first 10 CA
        tau_est = mod(lags_next(index_max_next), gpsc.spch*gpsc.chpc);
        if max_corr_next > best_correlation
            best_doppler_shift = k;
            best_tau = tau_est;
            best_correlation = max_corr_next;
        end
    end
    
end

doppler_estim = best_doppler_shift;
tau_estim = best_tau;
display(['Tau estim: ' num2str(best_tau)]);
ip_result = abs(best_correlation);

end



