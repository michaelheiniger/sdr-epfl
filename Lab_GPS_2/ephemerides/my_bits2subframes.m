%   BITS2SUBFRAMES Returns a matrix containing the subframes in the
%   desired order
%   [SUBFRAMES, SUBFRAMESIDS] = BITS2SUBFRAMES(BITS) returns the matrix
%   SUBFRAMES having as its columns the subframes extracted from BITS. 
%   The IDs of the subframes are returned in SUBFRAMESIDS.
%   BITS must be a row vector containing a concatenation of subframes 
%   (0 and 1 elements) that have already been checked for parity.
%   Provided that BITS is sufficiently long, SUBFRAMES contains the 
%   subframes with id 1,2,3, in that order. (It might contain additional subframes.)
%   These are the subframes that we use to obtain the ephemerides. 

function [subframes, subframes_ids] = my_bits2subframes(bits)

global gpsc;

% Number of subframes contained in the received bits
number_subframe = length(bits) / gpsc.bpsf;

% To store the subframes: one per row
subframes = zeros(gpsc.bpsf, number_subframe);

% To store the subframes IDs
subframes_ids = zeros(1, number_subframe);

% Keep count of the number of subframes to save into subframes_ids
i = 1;

% Iterate over the received bits, one subframe at a time
for k = 1:gpsc.bpsf:length(bits)
    current_sf = bits(k:k+gpsc.bpsf-1);
    
    subframes(k:k+gpsc.bpsf-1) = current_sf;
    
    % Read bits 50 to 52 of the subframe to get its ID
    subframes_ids(i) = bi2de(current_sf(50:52), 'left-msb');
    
    i = i + 1;
    
end

end