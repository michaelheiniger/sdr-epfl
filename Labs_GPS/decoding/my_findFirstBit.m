% FINDFIRSTBIT Scans the Doppler corrected data to locate the begining of a bit
% TAU = FINDFIRSTBIT(SAT_NUMBER,DOPPLER,TAU) reads the data starting
% at TAU (beginning of a C/A code as obtained by FINDSATELLITES()),
% corrects it for Doppler using the estimate DOPPLER, and uses the
% C/A code for satellite SAT_NUMBER to search for the beginning of
% a bit. The beginning  is declared if the phase of the inner 
% product after we shift by the length of a C/A code varies by 
% roughly pi (is in the range [-3*pi/4, 3*pi/4]).
% The function returns the index of the first sample of the 
% first bit received complete.

function tau_bit = my_findFirstBit(sat_number, doppler, tau) 

global gpsc;

fs = gpsc.fs;

ca_seq = satCode(sat_number, 'fs'); % One C/A code

% Do iteration of first chunk outside of for-loop to initialize previous_phase
t = 0:1/fs:(length(ca_seq)-1)/fs;
samples = getData(tau, tau+length(ca_seq)-1) .* exp(-1j*2*pi*doppler*t);

previous_phase = angle(ca_seq * transpose(samples));
k = 1; % Count of C/A code checked until bit changes
bit_not_found = 1;
while bit_not_found
   
    % Accounts for phase continuity since doppler is function of time
    t = k*length(ca_seq)/fs:1/fs:((k+1)*length(ca_seq)-1)/fs;
    
    % Load next chunk and remove Doppler shift
    samples = getData(tau+k*length(ca_seq), tau+(k+1)*length(ca_seq)-1) .* exp(-1j*2*pi*doppler*t);

    % Compute the phase of the current inner product
    current_phase = angle(ca_seq * transpose(samples));

    phase_diff = previous_phase - current_phase;
    
    % phase difference is in the [3/4pi;5/4pi] => bit has (likely) flipped
    bit_not_found = not ((abs(phase_diff) >= 3/4*pi) && (abs(phase_diff) <= 5/4*pi));
 
    previous_phase = current_phase;
    k = k + 1; 
end

% Accounts for the initial tau and for the possible skipped previous full bits
% (The -1 is due to the fact that k is incremented by 1 after the bit is
% found)
tau_bit = tau + mod((k-1)*length(ca_seq), 20*length(ca_seq));

end