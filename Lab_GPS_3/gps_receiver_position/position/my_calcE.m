function E_k= my_calcE(ephdata, t)

    % CALCE Obtain the satellite eccentric anomaly
    % E_k = calcE(ephdata, t)
    % 
    % ephdata: Ephemeris data of the satelite
    % E_k: eccentric anomaly
    % t: the GPS time for which we want to determine DeltaT
    %   
    %   To determine E_k, we need the formulas given in Table 20.IV
    %   (sheets 1 and 2), pp. 97-98 of the GPS standard document (Section 20.3.3.3.3.1)    
    
    global gpsc; % declare gpsc as global, so we can have access to it
    
    if isempty(gpsc)
		gpsConfig();
    end

    %Load data from ephdata for easier use (less messy code)
    a_s         = ephdata.sqrt_a ^ 2; % Semimajor axis
    delta_n     = ephdata.delta_n;    % Correction for mean motion
    M_0         = ephdata.M_0;        % Mean anomaly at reference time
    t_oe        = ephdata.t_oe;       % Ephemeris reference time
    e           = ephdata.e;          % Orbit ellipse eccentricity
    mu_e = gpsc.mu_e; 
        
    % Mean motion and corrected mean motion
    n_0 = sqrt(mu_e/(a_s)^3);
    n =  n_0 + delta_n;

    % Compute time since reference time and limit it to the correct range
    t_k = limitValidRange(t - t_oe);

    % Mean anomaly
    M_k =  M_0 + n*t_k;

    % Iterative algorithm to obtain eccentric anomaly E_k
    % We need to solve M_k = E_k - e * sin(E_k) for E_k; since there is no
    % analytic solution we use the iterative algorithm seen in class. 
    E_tolerance = 1e-14;
    
    % Initialize E_k
    E_k = M_k;
    
    while true
        
       % Update E_k
       E_k = M_k + e*sin(E_k);
       
       % Exit once E_K is close enough
       if (abs(E_k - (M_k + e*sin(E_k))) < E_tolerance)
           break;
       end
    end   
    
end % function calcE



