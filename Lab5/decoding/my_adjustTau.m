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
