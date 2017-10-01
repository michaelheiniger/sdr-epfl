% REMOVEEXCESSBITS Extracts the complete subframes in the bit sequence obtained from a satellite
%   [S, IDX] = REMOVEEXCESSBITS(BITS) detects the start of the first 
%   subframe in the  row vector BITS (values in {-1,+1}) by correlating with
%   the GPS preamble (stored in gpsc.preamble). 
%   If the negative of the preamble is found all bits are inverted. 
%   IDX is the index into BITS where the first subframe starts; incomplete 
%   subframes at the beginning and at the end of BITS are removed  and the 
%   sequence is converted into a sequence of  {0, 1} values and returned 
%   into vector S.  

% Hints:
% - Use gpsc.preamble
% - It is not enough to just find one preamble: the preamble is 8 bits long 
% and it is not unlikely that this 8-bit sequence is also present somewhere
% in the middle of the data sequence. You should use the fact that there is 
% one preamble in every subframe (every 300 bits).

function [s, index_first_subframe] = my_removeExcessBits(bits) 

global gpsc;

p = gpsc.preamble;

% Convert preamble to -1/+1 values (0 -> 1, 1 -> -1)
p(p == 1) = -1;
p(p == 0) = 1;

% Preamble extended to correlate with multiple subframes
% N is the number of subframes used to correlate with the preamble
N = floor(length(bits) / gpsc.bpsf)-1; % #Complete subframe
p_ext = [p, zeros(1, gpsc.bpsf - length(p))];
p_ext = repmat(p_ext, 1, N);

% Correlate the preamble with the decoded bits
R = round(xcorr(bits, p_ext));

% Remove the rampup and zero padding
R = R(length(bits):end);

% Get the position of the highest peak
[~, pos] = max(abs(R));

% 1 if value of correlation is negative => bits are flipped
bit_flipped = R(pos) < 0;

% Return index of first subframe
index_first_subframe = pos;

% Remove bits at begining belonging to previous incomplete subframe
bits = bits(index_first_subframe:end);

% Number of complete subframes in the decoded bits
complete_frame = floor(length(bits) / gpsc.bpsf);

% Remove bits at the end belonging to next incomplete subframe
bits = bits(1:complete_frame*gpsc.bpsf);

% Flip bits if needed
if (bit_flipped) 
    bits = -bits;
end

% Convert 1 to 0
bits(bits == 1) = 0;

% Convert -1 to 1 
bits(bits == -1) = 1;

s = bits;

end





