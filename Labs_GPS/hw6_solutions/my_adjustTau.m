% ADJUSTTAU Uses the current estimates of tau and Doppler to adjust tau
% NEWTAU = ADJUSTTAU(SAT_NUMBER, TAU, DELTATAU, DOPPLER)
% Integer SAT_NUMBER specifies the satellite we want to track
% TAU is the current estimate of the sample corresponding to the beginning 
% of the next unprocessed bit
% DELTATAU is the range (in number of samples) around the current estimate
% to be considered in the optimization (for instance, DELTATAU = (-2:1:2)
% to look at two samples before and two samples ahead of the current
% estimate)
% DOPPLER is the current estimate of the Doppler frequency
% The returned value NEWTAU will be in the range [TAU+min(DELTATAU),
% TAU+max(DELTATAU)]

function newTau = my_adjustTau(sat_number, tau, deltaTau, doppler)

    global gpsc; % declare gpsc as global, so we can access to it 
   
    % create 20 repetitions of the sampled C/A code, i.e., 1 bit
    p = satCode(sat_number,'fs');    % one repetition, 4 sample per chip
    p = repmat(p, 1, gpsc.cpb);      % 20 repetitions, 4 samples per chip

    tauRange = tau + deltaTau;
    
    % generate the complex exponential of frequency "doppler"
    dopplerCorrection = exp(-1j*2*pi*doppler* (0:length(p)-1) * gpsc.Ts);

    % compute the inner products over the range of tau being searched
    % and find the maximum absolute value
    innerProducts = zeros(length(tauRange), 1); % allocate storage
    for indexTau = 1:length(tauRange)
        y = getData(tauRange(indexTau), tauRange(indexTau) + length(p) - 1);
        innerProducts(indexTau) =  (y .* dopplerCorrection)*p';
    end    
    [dummy, index] = max(abs(innerProducts)); %#ok<ASGLU>
    newTau = tauRange(index);
