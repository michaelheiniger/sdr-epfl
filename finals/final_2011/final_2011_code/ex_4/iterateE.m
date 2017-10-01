function E = iterateE(M, e, E_tolerance)

% CALCDELTATANDE Obtain the satellite clock offset and eccentric anomaly
% E = iterateE(M, e, E_tolerance)
% 
% M: Mean anomaly 
% e: Orbit ellipse eccentricity
% E_tolerance: stop when the absolute value of the difference between two consecutively
% determined values is smaller than this parameter
%
% E: eccentric anomaly
   
%   To determine E, we need to iteratively solve E-e*sin(E)=M

% E0 = M
E = M;

while True
    E = M+e*sin(E);
    
   % Stop when the value of E is good enough
   if (abs(E-e*sin(E)-M) < E_tolerance)
       break;
   end
    
end
