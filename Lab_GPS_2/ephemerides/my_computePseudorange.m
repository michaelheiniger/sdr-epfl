% COMPUTEPSEUDORANGE Compute pseudorange for one GPS satellite
% PSEUDORANGE = COMPUTEPSEUDORANGE(TAUS, TAU_REF, TAU_FIRSTBITSUBFRAME)
% TAUS: vector of indices into the received samples where each decoded bit begins 
%   The length of TAUS is equal to the number of decoded bits
% TAU_REF: (scalar) index into the vector of received samples where the position of the receiver is to be computed
% IDX_FIRSTBITSUBRAME: index into the sequence of bits where the first subframe starts for this satellite
%
% PSEUDORANGE: computed pseudorange for the satellite (in meters)

function pseudorange = my_computePseudorange(taus, tau_ref, idx_firstBitSubframe)

global gpsc;

%tau_ref should be bigger than 0; (reference time should be after turning on the receiver)
%tau_ref considered to be lower than the start of the first complete
%subframe

% Find the index of the first bit that occurs after tau_ref
index_first_bit_after_tau_ref = find(taus >= tau_ref,1,'first');

% Number of full bits between first bit after tau_ref and first bit of the
% first occuring subframe
number_complete_bits = index_first_bit_after_tau_ref-idx_firstBitSubframe;

% number of samples between tau_ref and first bit found after tau_ref
number_samples = taus(index_first_bit_after_tau_ref)-tau_ref;

% Compute the variable (-> Doppler) number of samples per bit
samples_per_bit = taus(index_first_bit_after_tau_ref)-taus(index_first_bit_after_tau_ref-1);

% Fraction of bits between tau_ref and first bit found after tau_ref (< 1)
fraction_bits = number_samples / samples_per_bit;

% Time of one bit (from the satellite perspective: No Doppler)
Tb = gpsc.Tc * gpsc.cpb;

% Get pseudorange
pseudorange = gpsc.C * Tb * (number_complete_bits+fraction_bits);
    
% @Nicolae: Thanks for the really good indications !
    
    
end
