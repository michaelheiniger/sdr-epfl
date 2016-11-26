function Delta_t_SV_L1PY = my_calcDeltaT(ephdata, E_k, t)

    % CALCDELTAT Obtain the satellite clock offset 
    % Delta_t_SV_L1PY = calcDeltaT(ephdata, E_k, t)
    % 
    % ephdata: Ephemeris data of the satelite
    % E_k: eccentric anomaly
    % t: the GPS time for which we want to determine DeltaT
    
    % Delta_t_SV_L1PY: satellite clock offset

    %   To determine the clock offset we use formulas from Sections
    %   20.3.3.3.1 and 20.3.3.3.2, pages 88 and 90 

    function_mapper;
    global gpsc; % declare gpsc as global, so we can have access to it
    
    if isempty(gpsc)
		gpsConfig();
    end
    
    % Relativistic constant used to compute the satellite clock offset
    F = -2 * sqrt(gpsc.mu_e) / gpsc.C^2;

    % Load data from ephdata for easier use (less messy code)
    a_f0        = ephdata.a_f0;       % 0th order,
    a_f1        = ephdata.a_f1;       % 1st order, and
    a_f2        = ephdata.a_f2;       % 2nd order polynomial coefficients for correction term for satellite clock offset
    t_oc        = ephdata.t_oc;       % Clock data reference time
    T_GD        = ephdata.T_GD;       % Group delay differential

    sqrt_a         = ephdata.sqrt_a; % Semimajor axis
    e           = ephdata.e;          % Orbit ellipse eccentricity

    % Relativistic correction term (IS-GPS-200D 20.3.3.3.1, p.88)
    % (Not to be confused with the receiver clock bias which is also called Delta_t_r in the lecture)
    Delta_t_r =  F * e * sqrt_a * sin(E_k);

    % Time since clock error reference time; corrected to be in the range
    % [-302400, 302400]
    dt = limitValidRange(t - t_oc);

    % Compute satellite clock offset before L1 correction
    % (IS-GPS-200D, 20.3.3.3.1, p.88)
    Delta_t_SV = a_f0 + a_f1*dt + a_f2*dt^2 + Delta_t_r;

    % L1 correction (IS-GPS-200D, 20.3.3.3.3.2, p.90)
    Delta_t_SV_L1PY = Delta_t_SV - T_GD;

end % function calcDeltaT
