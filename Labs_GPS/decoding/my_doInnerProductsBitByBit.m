% DOINNERPRODUCTSBITBYBIT Does the inner product one bit at a time. 
%
% [NEWBITWISEINNERPRODUCT, NEXTINITIALPHI] = DOINNERPRODUCTSBITBYBIT(NBITS,SAT_NUMBER,DOPPLER,TAU,INITIALPHI)
% Returns in NEWBITWISEINNERPRODUCT the inner products of NBITS (done one 
% bit at a time) with repeated C/A code for  satellite SAT_NUMBER, applying 
% Doppler correction DOPPLER, and assuming that the first bit considered  
% starts at sample TAU and that the initial phase for the Doppler correction
% is INITIALPHI. 
% In NEXTINITIALPHI the function returns the initial phase for the Doppler 
% correction required to process the next block of bits in a subsequent 
% function call.

function [new_bitwise_inner_product, next_initial_phi] = my_doInnerProductsBitByBit(n_bits,sat_number,doppler,tau,initial_phi)

global gpsc;

fs = gpsc.fs;

ca_code = satCode(sat_number, 'fs'); % One C/A code
ca_repeat = repmat(ca_code, 1, gpsc.cpb);

inner_products = zeros(1, n_bits);

% No need to accounts for phase continuity in the time vector: 
% initial phase is updated at every iteration
t = 0:1/fs:(length(ca_repeat)-1)/fs;
for k = 0:n_bits-1
    % Load 1 bit of data
    samples = getData(tau+k*length(ca_repeat), tau+(k+1)*length(ca_repeat)-1);
    % Remove Doppler shift
    samples_wo_doppler = samples .* exp(-1j*(2*pi*doppler*t+initial_phi));
    
    % Save inner product
    inner_products(k+1) = ca_repeat * transpose(samples_wo_doppler);
    
    % Update the phase: this is what ensures phase continuity
    initial_phi = initial_phi + 2*pi*doppler*length(ca_repeat)/fs;
end

next_initial_phi = initial_phi;

new_bitwise_inner_product = inner_products;

end
