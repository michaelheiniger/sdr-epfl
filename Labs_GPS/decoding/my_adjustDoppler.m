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
% is a second order polynomial: with this three points we find the
% coefficients of this polynomial and then NEWDOPPLER corresponds to
% the point where the maximum of the parabola is found

function new_doppler = my_adjustDoppler(sat_number, tau, doppler, fcorr)

global gpsc; 
fs = gpsc.fs;

% Now that tau has been updated, we know that the following 20 C/A codes
% are about the same bit.
ca_code = satCode(sat_number, 'fs'); % One C/A
ca_rep = repmat(ca_code, 1,  gpsc.cpb);

doppler_shifts = [doppler-fcorr, doppler, doppler+fcorr]; 
inner_products = zeros(length(doppler_shifts), 1);

t = 0:1/fs:(length(ca_rep)-1)/fs;
samples = getData(tau, tau + length(ca_rep) - 1);
for k = 1:length(doppler_shifts)
    samples_corrected = samples .* exp(-1j*2*pi*doppler_shifts(k)*t);
    inner_products(k) = ca_rep * conj(transpose(samples_corrected));
end

d1 = doppler-fcorr;
d2 = doppler;
d3 = doppler+fcorr;

D = [ d1.^2, d1, 1 ; 
   d2.^2, d2, 1; 
   d3.^2, d3, 1 ];

f = [ inner_products(1); inner_products(2) ;inner_products(3) ]; 
result = D\abs(f);
a = result(1);
b = result(2);

new_doppler = -b/(2*a);

end