function llrout = sol_ldpcdecoder(llr0, numiter, H)

% LDPCDECODER Decode LDPC-encoded bit sequence
% LLROUT = LDPCDECODER(LLR0, NUMITER, H) performs decoding of an
% LDPC-encoded bit sequence using the sum-product algorithm on the
% code graph. LLR0 is a vector containing the initial log-
% likelihood ratios of the variable nodes; NUMITER is the number of
% iterations to perform, and H is the sparse parity-check matrix that
% describes the code. 
% LLR0UT is the vector of log-likelihood ratios of the variable nodes 
% output after the NUMITER decoding iterations.


    function_mapper;

    % check if decmatrices.mat exist in disk; if it does, load it in memory 
    % and verify that the stored matrices correspond with the H passed as
    % third parameter in the function call, otherwise call generateDecodingMatrices()
    % to generate the encoding submatrices
    generate = true;
    matfile = 'decmatrices.mat';
    if exist(matfile, 'file')
        aux = load(matfile);
        H_file = aux.H;
        % fprintf(1, 'Loading decoding matrices from file %s ...', matfile);        
        if (any(size(H)~=size(H_file)) || any(H(:) ~= aux.H(:)))
            warning('ldpcdecoder:HdiffersFromSaved', 'The parity check matrix passed differs from the one found on disk');            
        else
            socket = aux.socket; Mct = aux.Mct; Mvt = aux.Mvt;
            clear('aux');
            % fprintf(1, 'OK\n');
            generate = false;            
        end
    end
        
    if generate
        %fprintf(1, 'Generating decoding matrices\n');
        [socket, Mct, Mvt] = generateDecodingMatrices(H);
        % You can uncomment the line below ONLY after you are sure that your code for generateDecodingMatrices is obtaining
        % the correct results.
        %save(matfile, 'socket', 'Mct', 'Mvt', 'H'); % save results for later reuse        
    end
	
	% Make sure that the input is a column vector
	llr0 = llr0(:);
    if (length(llr0) ~= size(H,2))
        error('ldpcdecoder:wrongInputLength', 'Input LLR must be a vector of length equal to the number of columns in matrix H');
    end

	% Assign first messages (initial LLR's)
	% (By indexing with socket(:,1), we assure that a given variable node's LLR
	% is repeated in vtoc for the number of edges leaving from the node.)
	vtoc = llr0(socket(:,1));

	% llr0hard = double(llr0 < 0);

		
	for k = 1:numiter

	    	%fprintf('Message passing algorithm, iteration %d of %d...', k,	numiter); % debugging trace

	    	% CHECK NODE CALCULATIONS
	    	% Take log of coth to be able so sum rather than multiply the incoming edges at check nodes
	    	modin = log(abs(coth(vtoc/2)));
	    	signin = (vtoc < 0); % 0 for positive, 1 for negative.

	    	% Compute sum at check nodes
	    	signout = mod(Mct * signin, 2);
	    	modout = Mct * modin;

	    	% Expand from one entry per check node to one entry per socket
		% and subtract the incoming value for 'itself'
	    	signout = mod(signout(socket(:,2)) - signin, 2);
	    	modout = modout(socket(:,2)) - modin;

	    	% Compute final check-to-variable message by combining sign with modulus
	    	ctov = 2 * (1 - 2*signout) .* acoth(exp(modout));
	    	ctov = reduceinf(ctov); % eliminate inf values

	    	% VARIABLE NODE CALCULATIONS
	    	% Simply sum incoming log-likelihood ratios at variable nodes
	    	llr = Mvt * ctov + llr0;

	    	% Get rid of any Infs
	    	llr = reduceinf(llr);

	    	% Expand from one entry per variable node to one entry per socket
		% and subtract  the incoming value for 'itself'
	    	vtoc = llr(socket(:,1)) - ctov;
    	
	end % for k = 1:numiter

	% make the dimension (row or column) of llrout the same as that of llr0
	llrout = reshape(llr, size(llr0));


end % function ldpcdecoder

function x = reduceinf(x)

	MYMAX = 1e10; % Cap infinity values above MYMAX and below -MYMAX
	x(x == Inf) = MYMAX;
	x(x == -Inf) = -MYMAX;	

end % function reduceinf