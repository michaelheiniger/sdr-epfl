% ADJUSTTAU Uses the current estimates of tau and Doppler to adjust tau
% NEWTAU = ADJUSTTAU(SAT_NUMBER, TAU, DELTATAU, DOPPLER)
% Integer SAT_NUMBER specifies the satellite we want to track
% TAU is the current estimate of the sample corresponding to the beginning 
% of the next unprocessed bit
% DELTATAU is the range (in number of samples) around the current estimate
% to be considered in the optimization (for instance, DELTATAU = (-2:1:2)
% to look at two samples before and two samples ahead of the current
% estimate)
% DOPPLER is the current estimate of the Doppler frequency
% The returned value NEWTAU will be in the range [TAU+min(DELTATAU),
% TAU+max(DELTATAU)]

function new_tau = my_adjustTau(sat_number, tau, deltatau, doppler)

global gpsc;

fs = gpsc.fs;

ca_seq = satCode(sat_number, 'fs'); % One C/A code

best_tau = tau;
max_inner_product = 0;
for dtau = deltatau
    
    current_tau = tau+dtau;
    t = 0:1/fs:(length(ca_seq)-1)/fs;
    samples = getData(current_tau, current_tau+length(ca_seq)-1) .* exp(-1j*2*pi*doppler*t);
    
    inner_product = abs(ca_seq * transpose(samples));
    if inner_product > max_inner_product
       max_inner_product = inner_product;
       best_tau = current_tau;
    end
end

new_tau = best_tau;
end
