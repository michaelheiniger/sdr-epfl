% LDPCENCODE Encoder for binary LDPC codes
%   CW = LDPCENCODE(S, H) encodes the information bit vector S
%   according to the code specified by the parity check matrix H. 
%   H is an m x n binary sparse matrix, and S is the input vector
%   (n-m bits) CW is the output codeword (vector of n bits).
%
% The algorithm followed is from Richardson/Urbanke: Efficient
% Encoding of Low-Density Parity Check codes, IEEE Transactions on
% Information Theory, Vol. 47, No. 2, February 2001.

function x = my_ldpcencoder(s, H)

    function_mapper;

    % check that input is a binary vector of the right dimensions
    s = s(:); % Turn the input into a column vector if required
    if (length(s) ~= (size(H,2)-size(H,1)))
        length(s)
        size(H,2)-size(H,1)
        error('ldpcencode:inconsistentDimensions', ...
              'The length of the input vector is inconsistent with the size of the parity check matrix H');
    end
    if any((s~=0) & (s~=1))
        error('ldpcencode:nonBinaryInput', 'Input vectos s must be a vector of bits (0 and 1 elements)');
    end

    % check if encmatrices.mat exist in disk; if it does, load it in memory 
    % and verify that the stored matrices correspond with the H passed as
    % second parameter in the function call, otherwise call extractmatrices()
    % to generate the encoding submatrices
    generate = true;
    matfile = 'encmatrices.mat';
    if exist(matfile, 'file')
        aux = load(matfile);
        fprintf(1, 'Loading matrices from file %s ...', matfile);
        A = aux.A; B = aux.B; C = aux.C; D = aux.D; E = aux.E; T = aux.T; phiinv = aux.phiinv;
        H_file = [A B T; C D E];
        if any(H(:) ~= H_file(:))
            warning('ldpcencoder:HdiffersFromSaved', 'The parity matrix passed differs from the one found on disk');            
        else
            fprintf(1, 'OK\n');
            generate = false;            
        end
    end

    if generate
        fprintf(1, 'Generating encoding matrices\n');
        [A, B, C, D, E, T, g, m, n] = my_extractmatrices(H);
        
        T = double(T); % make sure that T is double, not logical, otherwise we cannot compute its inverse or use it with the \ operator
    
        phi = mod(-E * (T\B)  + D, 2);
        phiinvGF = inv(gf(full(phi)));
        phiinv = double(phiinvGF.x); % with .x we recover just the 0, 1 elements, but since they are stored as uint32 in phiinvGF, we need to convert them to double
    
        % You can uncomment the line below ONLY after you are sure that your code for extractmatrices and calculating phiinv is obtaining
        % the correct results. You should notice some speed increase once you have pre-computed the matrices A,B, etc. and phiinv
        %save(matfile, 'A', 'B', 'C', 'D', 'E', 'T', 'phiinv', 'g', 'm', 'n', 'H'); % save results for later reuse        
    end
    
    tic;
    % Compute p1
    p1 = mod(phiinv * (-E *(T\(A*s)) + C*s), 2); % This turns out to be much faster
    
    % Compute p2    
    p2 = mod(T\(A*s + B*p1),2); % This turns out to be much faster

    x = [s; p1; p2];
    disp('My code (just encoding): '); toc;

    %% Sanity check: 
    % verify that the codeword does indeed fulfill all parity check equations
    if any(mod(H * x, 2))
        error('ldpcencode:invalidCodeword', 'Codeword did NOT verify parity check');
    end
    
    x = x'; % output row vector

end


