% ADJUSTDOPPLER Tracks the evolution of the Doppler frequency
% NEWDOPPLER = ADJUSTDOPPLER(SAT_NUMBER, TAU, DOPPLER, FCORR)
% SAT_NUMBER selects the satellite we want to track, TAU is the
% current estimate of the sample corresponding to the beginning 
% of the next unprocessed bit and DOPPLER is the current Doppler
% estimate.
% The estimation method is based in computing the inner products
% of the C/A code repeated 20 times (duration of a bit) with
% the received signal corrected with the current estimate of the
% Doppler and corrected with a value slightly higher (DOPPLER+FCORR)
% and a value slightly lower (DOPPLER-FCORR). From experiments
% we know that the value of the inner product as a function of Doppler
% is a second order polinomial: with this three points we find the
% coefficients of this polynomial and then NEWDOPPLER corresponds to
% the point where the maximum of the parabola is found

function newDoppler = my_adjustDoppler(sat_number, tau, doppler, fCorr)

    global gpsc; 
    
    % The idea is to compute the inneer product at three points, namely at the
    % current Doppler estimate as well as fCorr Hz before and fCorr Hz
    % after. We know (from experiments) that the top of the curve that plots
    % the absolute value of the inner product as a function of the Doppler can
    % be approximated by a second degree polynomial of the form ax^2+bx+c.
    % Hence we find the coefficients of the second degree polynomial that goes
    % through the calculated points. The value of x that corresponds to the
    % maximum is then -b/(2a)
    
    % create 20 repetitions of the sampled C/A code, i.e., 1 bit
    p = satCode(sat_number, 'fs');   % one repetition, 4 samples per chip % row vector
    p = repmat(p, 1, gpsc.cpb);      % 20 repetitions, 4 samples per chip % row vector
    
    dopplerRange = doppler + [-fCorr, 0, fCorr]; 

    innerProducts = zeros(length(dopplerRange), 1); % column vector

    y = getData(tau, tau + length(p) - 1);
    for indexDoppler = 1:length(dopplerRange)
        dopplerCorrection = exp(-1j*2*pi*dopplerRange(indexDoppler)* (0:length(p)-1) * gpsc.Ts);
        innerProducts(indexDoppler) =  (y .* dopplerCorrection)*p';
    end

    % At this point we have the three inner-product results stored in the vector innerProducts
    % Next we find a, b, and c:
    % the idea is to write three equations of the form ax^2 + bx +c = r
    % where in each equation x is set to the Doppler and r is the absolute value of the inner
    % product. These are three linear equations in the three indetermnates a, b, and c. We can let
    % Matlab solve for a, b, and c, using the backslash operator (see "help mldivide")

    % abc is a length three vector that contains a, b, and c. 
    abc = [dopplerRange.'.^2 dopplerRange.' ones(length(dopplerRange), 1)]\abs(innerProducts);

    % in order for the sattle point to be a maximum, the coefficient "a" has to
    % be positive. Let us check that this is indeed the case. 
    if abc(1) >= 0
        warning('LCM:LoosingSync', 'Unable to find nu max => Sync lost.'); % Nicolae: to see where it comes from
        error('LCM:SyncLost', 'Unable to find nu max => Sync lost\n');
    end

    newDoppler = -abc(2)/(2*abc(1));

    % let us generate an error if the change is bigger than expected. 
    if (abs(doppler - newDoppler) > fCorr/2)
        fprintf(1, 'Warning: big Doppler change (%d -> %d).\n', round(newDoppler), round(doppler));
        warning('LCM:SyncLost', 'Too big Doppler change\n');
    end
