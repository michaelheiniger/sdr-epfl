% ESTABLISH_PARITY Checks the parity of the GPS subframes 
%    S = ESTABLISH_PARITY(WS) checks the parity of one or more 
%    subframes WS and flips the bits where necessary according to 
%    the GPS parity algorithm. If the parity check fails, 
%    a warning is issued; otherwise a message indicating success 
%    is displayed. Both the input WS and the output S are binary 
%    (0 and 1) row vectors containing a multiple of subframes.


function s = my_establishParity(ws)
    
    % declare gpsc as global, and if it is not initialized, do it
    global gpsc;
    if isempty(gpsc)
        gpsConfig();
    end	

    % Parity check matrix (cf. GPS standard)
    H = [...
        1 0 1 0 1 0 % d1
        1 1 0 1 0 0 % d2 
        1 1 1 0 1 1 % ...
        0 1 1 1 0 0
        1 0 1 1 1 1
        1 1 0 1 1 1
        0 1 1 0 1 0
        0 0 1 1 0 1
        0 0 0 1 1 1
        1 0 0 0 1 1
        1 1 0 0 0 1
        1 1 1 0 0 0
        1 1 1 1 0 1
        1 1 1 1 1 0
        0 1 1 1 1 1
        0 0 1 1 1 0
        1 0 0 1 1 0
        1 1 0 0 1 0
        0 1 1 0 0 1
        1 0 1 1 0 0
        0 1 0 1 1 0
        0 0 1 0 1 1
        1 0 0 1 0 1
        0 1 0 0 1 1 % d24
        1 0 1 0 0 1 % D29*
        0 1 0 1 1 0 % D30*
        ];

    % Other needed parameters
    BPW = 30;             % Bits per word
    DBPW = 24;            % Databits per word

    % Check parameter validity
    nsf = length(ws) / gpsc.bpsf;
    if nsf ~= floor(nsf)
        error('WS must contain a multiple of subframes');
    end

    % Total number of words
    nw = nsf * gpsc.wpsf;

    % Flag to indicate whether parity check passed. Set this to false if you
    % detect a parity error somewhere. 
    passed = true;

    % COMPLETE THE ALGORITHM HERE
    % Note: For the first word of WS, you can assume that D29* and D30* are
    % zero (the last two bits of the last word of a subframe are always
    % zero).
    s = zeros(1, nw*BPW);
    
    D29_prev = 0;
    D30_prev = 0;
    for k = 1:BPW:length(ws)
        % Load current word
        word = ws(k:k+BPW-1);
        
        if (D30_prev == 1)
            % Invert the first DBPW bits
            word = [abs(word(1:DBPW)-1), word(DBPW+1:end)]; 
        end
        
        % Compute parity bits D25,...,D30
        parity = mod([word(1:DBPW), D29_prev, D30_prev] * H, 2);
        
        % Check computed parity bits with received parity bits
        if (sum(parity ~= word(DBPW+1:end)) > 0)
           passed = false;
        end
        
        % Update last two bits
        D29_prev = word(end-1);
        D30_prev = word(end);
        
        % Save databits of current word
        s(k:k+BPW-1) = word;
    end
       
    % Display a warning if there was an error
    if ~passed
        error('establishParity:unsuccessful', 'Parity check failed.');
    else
         fprintf(1, 'Parity check passed\n');
    end
