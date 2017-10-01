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

function tau = my_findFirstBit(sat_number, doppler, tau)

    global gpsc; % declare gpsc as global, so we can access to it

    p = satCode(sat_number, 'fs'); % C/A code with 4 sample per chip

    % get an intial inner product as reference
    y = getData(tau, tau + length(p) - 1); 
    t = gpsc.Ts * (0 : length(p)-1);
    dopplerCorrection = exp(-1j * 2*pi*doppler * t);
    lastInnerProduct =  (y .* dopplerCorrection)*p';
    
    % do the actual search: we try to find a bit change, i.e, a jump of pi in the
    % projections of the codes. If there is one, we set found to true
    % otherwise there is no bitchange in the current block and we need to search in the next block.
    found = false; 
    
    while ~found

        tau = tau + length(p); % advance by the length of a C/A code
        y = getData(tau, tau + length(p) - 1); % get the corresponding data

        innerProduct = (y .* dopplerCorrection)*p';

        % we need to correct the inner product result since the initial phase of the dopplerCorrection has been reset to zero 
        % rather than being the final phase of the previous pass increased by one step.       
        correctedInnerProduct = innerProduct * exp(-1j*2*pi*doppler*length(p)*gpsc.Ts); 

        % set found to "true" when the real part of the product is negative,
        % i.e., the angle has changed by roughly pi.
        %found = (real(correctedInnerProduct * conj(lastInnerProduct)) < 0);
        % Nicolae: for a safer estimation, reduce the decision zone. 
        found = (abs(angle(correctedInnerProduct * conj(lastInnerProduct))) > 3*pi/4);
        lastInnerProduct = innerProduct;
           
    end
    
    % return the tau (in number of samples) that corresponds to the beginning of the FIRST bit
    tau = mod(tau, gpsc.cpb * length(p));
