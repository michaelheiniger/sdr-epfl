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

ca_one = satCode(sat_number, 'fs');
N = 10; % Number of CA codes for the cross-correlation
ca_repeat = repmat(ca_one, 1, N);

% To be sure you get 10 full CAs
% for each chunk of 10 CAs you need data of length 10*CA + CA - 1: in this
% way you are sure you have 10 complete (and not more!) CA's
samples = getData(1, 2*(length(ca_repeat) + gpsc.spc) - 2);

% Split loaded data into two disjoint chunks to see in which one 
% the full 10 CA reside
data_seq_1 = samples(1:length(ca_repeat) + gpsc.spc - 1);
data_seq_2 = samples(length(ca_repeat) + gpsc.spc:end);

% Save the tau corresponding to the max correlation
best_tau = 0;

% Time axis used to correct for Doppler shift
t = (0 : length(data_seq_1)-1) * gpsc.Ts;

% Range of Doppler shifts to try
doppler_shift = -gpsc.maxdoppler/2:doppler_step:gpsc.maxdoppler/2;

% Save the value of the max correlation
best_correlation = 0;

% Save the value of the Doppler shift that gives the max correlation
best_doppler_shift = 0;

% Exhaustive search of the best Doppler shift in the given range
for k = doppler_shift
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Correct for Doppler: Remove Doppler shift 
    % This needs to be done before computing the cross-correlation
    % in order to optimize the results since the reference signal and 
    % the received signal have different frequency due to Doppler shift
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    shifted_data_1 = exp(-1j*2*pi*k*t).*data_seq_1;
    shifted_data_2 = exp(-1j*2*pi*k*t).*data_seq_2;
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Cross-correlation of reference signal with received signal to find
    % tau and synchronize on the sample level
    % max() must be used since the CA code is multiplied by -1 or +1
    % and the reference sequence corresponds to +1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Data part 1
    [R1, ~] = xcorr(shifted_data_1, ca_repeat);
    
    % Tau cannot be < 0 since the max must be when overlap is complete
    R1 = R1(length(shifted_data_1):end);
    
    % Tau cannot be > Ta*fs where Ta is the time of a full CA code
    R1 = R1(1:length(ca_repeat));
    [max_corr_data_1, tau1] = max(abs(R1));
    
    % Data part 2
    [R2, ~] = xcorr(shifted_data_2, ca_repeat);
    
    % Tau cannot be < 0 since the max must be when overlap is complete
    R2 = R2(length(shifted_data_2):end);
    
    % Tau cannot be > Ta*fs where Ta is the time of a full CA code
    R2 = R2(1:length(ca_repeat));
    [max_corr_data_2, tau2] = max(abs(R2));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Take the max of the correlation between the 2 disjoint parts of the 
    % received signal. 
    % If the resulting value is higher than the maximum correlation so far,
    % the best value is saved and the tau and Doppler shifts estimates are
    % updated as well.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if max_corr_data_1 > max_corr_data_2 % bit transition occurs in data part 2
        if max_corr_data_1 > best_correlation
            best_doppler_shift = k;
            best_tau = tau1;
            best_correlation = max_corr_data_1;
        end
    else % bit transition occurs in data part 1
        if max_corr_data_2 > best_correlation
            best_doppler_shift = k;
            best_tau = tau2;
            best_correlation = max_corr_data_2;
        end
    end
    
end

doppler_estim = best_doppler_shift;

% Take modulo here to get the start of the first CA
tau_estim = mod(best_tau, gpsc.spc);

%display(['Tau estim: ' num2str(best_tau)]);

ip_result = abs(best_correlation);

end


