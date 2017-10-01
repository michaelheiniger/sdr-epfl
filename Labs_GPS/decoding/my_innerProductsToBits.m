% INNERPRODUCTSTOBITS Make hard decisions about the transmitted bits
% DECODEDBITS = INNERPRODUCTSTOBITS(BITWISEINNERPRODUCTRESULTS)
% Returns in DECODEDBITS a vector of the same dimensions as 
% BITWISEINNERPRODUCTS with the hard decisions about the transmitted bits.
% The elements of DECODEDBITS are 1 or -1
function decoded_bits = my_innerProductsToBits(bitwise_inner_product_results)

decoded_bits = zeros(1, length(bitwise_inner_product_results));


% Since we are not able to correct the phase yet, we decide arbitrarily
% that the first bit is 1 and decode the following bits accordingly 
% (i.e. every bit with essentially the same phase as the first bit will 
% be decoded as 1 and the others as -1).
decoded_bits(1) = 1; 

% Phase of previous bit
phase_prev_bit = angle(bitwise_inner_product_results(1));

% Actual value of previous bit: {-1,+1}. 
% Initialized to 1 according to our convention
previous_bit = 1;

% Decode bit-by-bit using only the previous bit as reference
for k = 2:length(bitwise_inner_product_results)
    
    phase_current_bit = angle(bitwise_inner_product_results(k));
    phase_diff = phase_current_bit - phase_prev_bit;
    
    % abs phase diff. in (pi/2;3pi/2) => current bit is different than
    % previous bit
    if (abs(phase_diff) > pi/2) && (abs(phase_diff) < 3/2*pi)
        decoded_bits(k) = -previous_bit; 
        previous_bit = -previous_bit; % Previous bit is now different
    else 
        decoded_bits(k) = previous_bit;
    end
    
    phase_prev_bit = phase_current_bit;
end

end