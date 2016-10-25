% DOINNERPRODUCTSBITBYBIT Does the inner product one bit at a time. 
%
% [NEWBITWISEINNERPRODUCT, NEXTINITIALPHI] = DOINNERPRODUCTSBITBYBIT(NBITS,SAT_NUMBER,DOPPLER,TAU,INITIALPHI)
% Returns in NEWBITWISEINNERPRODUCT the inner products of NBITS (done one 
% bit at a time) with repeated C/A code for  satellite SAT_NUMBER, applying 
% Doppler correction DOPPLER, and assuming that the first bit considered  
% starts at sample TAU and that the initial phase for the Doppler correction
% is INITIALPHI. 
% In NEXTINITIALPHI the function returns the initial phase for the Doppler 
% correction required to process the next block of bis in a subsequent 
% function call.
