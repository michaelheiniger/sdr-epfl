function t = timeInterval(taus, ind1, B)
% TIMEINTERVAL Computes the time interval in which the satellite
% transmitted the signal between ind1 and the start of decoded bit number B
% TAUS: vector of indices into the received samples where each decoded bit begins
% IND1: (scalar) index into the vector of received samples showing the start of the analyzed interval

%check that ind1 and B > 0 
    if (ind1<=0 || B<=0)
         error('ind1 and B should be higher than zero');
    end
    
%check that ind1 <= taus(B) 

if (ind1>taus(B))
         error('ind1 should be smaller than taus(B)');
end

    
%bit duration in seconds (at the satellite)
Tb=0.02;







