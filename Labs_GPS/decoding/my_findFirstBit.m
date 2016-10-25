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
