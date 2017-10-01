% INNERPRODUCTSTOBITS Make hard decisions about the transmitted bits
% DECODEDBITS = INNERPRODUCTSTOBITS(BITWISEINNERPRODUCTRESULTS)
% Returns in DECODEDBITS a vector of the same dimensions as 
% BITWISEINNERPRODUCTS with the hard decisions about the transmitted bits.
% The elements of DECODEDBITS are 1 or -1

function decodedBits = my_innerProductsToBits(bitwiseInnerProductResults)

    % plot(angle(bitwiseInnerProductResults),'*'); % 

    decodedBits = zeros(size(bitwiseInnerProductResults));
    % decide that the first bit is a 1 (If it was a -1, we will correct this later on, see next assignment)
    decodedBits(1) = 1;
    for k = 2:length(decodedBits)
        diff = bitwiseInnerProductResults(k)*conj(bitwiseInnerProductResults(k-1));
        decodedBits(k) = sign(real(diff))*decodedBits(k-1);
        % or to eliminate the ambiguity of sign(0) = 0
        decodedBits(k) = (1-2*(real(diff) < 0))*decodedBits(k-1);
    end
    
    % here we throw a warning message if some of the transitions are not very neat
    diff = bitwiseInnerProductResults(2:end) .* conj(bitwiseInnerProductResults(1:end - 1));
    if (max(mod(angle(diff) + pi/4, pi)) > pi/2) % i.e, if the phase difference is more than pi/4 away from a multiple of pi
        warning('LCM:InnerProductsToBits', 'Some bit transitions are not very neat (%d/%d)... could lead to failing the parity check.', sum(mod(angle(diff) + pi/4, pi) > pi/2), length(diff)); % Nicolae
    end
    
%% The variant below is more compact but less readable
%     diff = bitwiseInnerProductResults(2:end) .* conj(bitwiseInnerProductResults(1:end - 1));
% 
%     % has error?
%     if (max(mod(angle(diff) + pi/4, pi)) > pi/2) % i.e, if the phase difference is more than pi/4 away from a multiple of pi
%         % fprintf(1, 'Warning (innerProductsToBits): wrong diff angle on decode bits (%d/%d) => Sync can be lost\n', sum(mod(angle(diff) + pi/4, pi) > pi/2), length(diff)); % commented out by Nicolae
%         warning('LCM:InnerProductsToBits', 'Some bit transitions are not very neat (%d/%d)... could lead to failing the parity check.', sum(mod(angle(diff) + pi/4, pi) > pi/2), length(diff)); % Nicolae
%     end
% 
%     % bit change if diff < 0
%     diff_b = (real(diff) < 0);
%     
%     %consider first bit
%     diff_b=[1, diff_b];
%     
%     % Integrate to have bits value
%     b = cumsum(diff_b);
%     decodedBits = 2*mod(b, 2)-1;


