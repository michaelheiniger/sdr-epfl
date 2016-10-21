% FINE_ESTIMATE Refine estimates of the Doppler shift in a GPS signal
% [DOPPLER_ESTIM_F,IP_RESULT]=FINE_ESTIMATE(SAT_NUMBER,TAU_ESTIM,
%   DOPPLER_ESTIM_C,DOPPLER_STEP)
% Improve the estimation of the Doppler shift corresponding to 
% satellite SAT_NUMBER doing a refined search around the coarse
% estimate DOPPLER_ESTIM_C, by doing inner products (rather than 
% correlations) with multiple repetitions of its C/A code 
% (In our case the number of repetitions is 10)
% TAU_ESTIM is the estimation obtained from COARSE_ESTIMATE().
% The search grid for the estimation is centered around 
% DOPPLER_ESTIM_C and its resolution (in Hz) is given by DOPPLER_STEP.
% The search range is COARSE_ESTIMATE + 20*DOPPLER_STEP*[-1 1].
% The outputs of the function are an improved estimation 
% DOPPLER_ESTIM_F of the Doppler shift and the absolute 
% value of the inner product between the repeated C/A code
% appropriately shifted and the Doppler corrected received signal.

function [doppler_estim_f, ip_result] = fine_estimate(sat_number,tau_estim, doppler_estim_c, doppler_step)

global gpsc;

ca_seq = satCode(sat_number, 'fs');
ca_seq = repmat(ca_seq, 1, 10);

% Load data taking into account the tau estimate (remove the first
% tau_estim samples)
samples = getData(tau_estim, tau_estim+2*length(ca_seq)-1);


first_10_ca = samples(1:length(ca_seq));
next_10_ca = samples(length(ca_seq)+1:end);

fs = gpsc.fs;

% Search area for fine doppler estimate is centered around coarse doppler estimate
max_doppler = doppler_estim_c+20*doppler_step;
min_doppler = doppler_estim_c-20*doppler_step;
doppler_shift = min_doppler:doppler_step:max_doppler;

t = 0:1/fs:(length(samples)/2-1)/fs;

best_doppler_shift = 0;
max_inner_product = 0;

for k = doppler_shift
    % Remove doppler shift
    shifted_first_10_ca = exp(-1j*2*pi*k*t).*first_10_ca;
    shifted_next_10_ca = exp(-1j*2*pi*k*t).*next_10_ca;
        
    % Compute inner products (take absolute value for comparison)
    inner_product_first = abs(shifted_first_10_ca * transpose(ca_seq));    
    inner_product_next = abs(shifted_next_10_ca * transpose(ca_seq));
    
    % Save doppler shift if it is the best so far
    if inner_product_first > inner_product_next && inner_product_first > max_inner_product
            best_doppler_shift = k;
            max_inner_product = inner_product_first;        
    else if inner_product_next > inner_product_first && inner_product_next > max_inner_product
            best_doppler_shift = k;
            max_inner_product = inner_product_next;
        end
    end
end

doppler_estim_f = best_doppler_shift;
ip_result = max_inner_product;

end