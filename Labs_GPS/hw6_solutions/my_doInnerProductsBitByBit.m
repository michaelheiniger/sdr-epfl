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

function [newBitwiseInnerProduct, nextInitialPhi] = my_doInnerProductsBitByBit(nBits, sat_number, doppler, tau, initialPhi)

    global gpsc; % declare gpsc as global, so we can access to it

    % initialize the variables:
    % - create 20 repetitions of the sampled C/A code
    p = satCode(sat_number, 'fs');   % one repetition, 4 samples per chip
    p = repmat(p, 1, gpsc.cpb);      % 20 repetitions, 4 samples per chip
    
    % - vector to correct for Doppler
    dopplerCorrection = exp(-1j*2*pi*doppler* (0:length(p)-1) *gpsc.Ts);

    % do the inner products bit by bit
    newBitwiseInnerProduct = zeros(1, nBits); % allocate space for results
    for bit = 1:nBits
        
       y = getData(tau + (bit - 1) * length(p), tau + bit * length(p) - 1);
       newBitwiseInnerProduct(bit) =  (y .* dopplerCorrection)*p';
       
       % we need to correct the inner product result since the initial phase of the dopplerCorrection has been reset to zero 
       % rather than being the final phase of the previous pass increased by one step.       
       newBitwiseInnerProduct(bit) = newBitwiseInnerProduct(bit) * exp(-1j*initialPhi);
       initialPhi = initialPhi + 2*pi*doppler*length(p)*gpsc.Ts;
       
    end

    nextInitialPhi = initialPhi;

    % uncomment to plot    
    %{
    diff = newBitwiseInnerProduct(2:end).*conj(newBitwiseInnerProduct(1:end - 1));
    subplot(1, 2, 1); plot(angle(newBitwiseInnerProduct), '*'); ylim([-pi pi]); title('Phase of Inner product bit by bit')
    subplot(1, 2, 2); plot(angle(diff), '*'); ylim([-pi pi]); title('Phase of ip(n) * ip(n+1)''')
    pause(0.01)
    %}    

end % function doInnerProductsBitByBit
