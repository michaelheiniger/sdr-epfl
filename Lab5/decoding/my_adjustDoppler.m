% ADJUSTDOPPLER Tracks the evolution of the Doppler frequency
% NEWDOPPLER = ADJUSTDOPPLER(SAT_NUMBER, TAU, DOPPLER, FCORR)
% SAT_NUMBER selects the satellite we want to track, TAU is the
% current estimate of the sample corresponding to the beginning 
% of the next unprocessed bit and DOPPLER is the current Doppler
% estimate.
% The estimation method is based in computing the inner products
% of the C/A code repeated 20 times (duration of a bit) with
% the received signal corrected with the current estimate of the
% Doppler and corrected with a value slightly higher (DOPPLER+FCORR)
% and a value slightly lower (DOPPLER-FCORR). From experiments
% we know that the value of the inner product as a function of Doppler
% is a second order polinomial: with this three points we find the
% coefficients of this polynomial and then NEWDOPPLER corresponds to
% the point where the maximum of the parabola is found
