% MY_DE2BI Convert decimal numbers to binary numbers
% B = MY_DE2BI(D) converts a vector D of nonnegative integers from base 10 
% to a binary matrix B. Each row of the binary matrix B corresponds to one
% element of D. The default orientation of the binary output is
% Right-MSB, i.e., the first element in a row of B represents the least
% significant bit. If D is a matrix rather than a row or column vector, the
% matrix is first converted to a vector (column-wise).
%
% In addition to the input vector D, two optional parameters can be given:
%
% B = MY_DE2BI(D,MSBFLAG) uses MSBFLAG to determine the output
% orientation. MSBFLAG has two possible values, 'right-msb' and
% 'left-msb'. Giving a 'right-msb' MSBFLAG does not change the
% function's default behavior. Giving a 'left-msb' MSBFLAG flips the
% output orientation to display the MSB to the left.
%
% B = MY_DE2BI(D,MSBFLAG,N) uses N to define how many binary digits (columns)
% are output. The number of bits must be large enough to represent the
% largest number in D.

% $Id: my_de2bi.m 1498 2012-11-28 18:23:18Z jimenez $

function b = my_de2bi(d, msbflag, n)

    if ~isfloat(d)
        d = double(d);
        % Promote input to double, so that we can handle other types (uint8, etc)
        % This is necessary since log2 can only handle doubles, and other
        % functions used below, such as kron, cannot mix double and uint
        % inputs
    end
    
    % Convert d to column if necessary
    d = d(:);
    
	% Check number of arguments and assign default values as necessary	
    nmax = max(1, floor(1+log2(double(max(d)))));    
	if (nargin < 3)
		n = nmax;       
	elseif (nmax > n)
		error('my_de2bi:insufficientNbits', ...
            'Specified number of bits is is too small to represent some of the decimal inputs,\nat least %d bits are required', nmax);
	end			
					
	if (nargin < 2)	
		msbflag = 'right-msb';
	end
	
	% Make sure input is nonnegative decimal
    if any((d < 0) | (d ~= fix(d)) | isnan(d) | isinf(d))
        error('my_de2bi:invalidInput', 'Input must contain only finite real positive integers.');
    end

    % Convert d to column if necessary
	d = d(:);
    
    
    % -------------------- % 
    % Best approach
    switch lower(msbflag)
		case 'left-msb'
			shifts=-(n-1:-1:0);
		case 'right-msb'
			shifts=-(0:n-1);
		otherwise
			error('my_de2bi:wrongMSBflag', 'Unsupported value for MSBFLAG');
    end
        
    %a1 = repmat(d, size(shifts));
    %a2 = repmat(shifts, size(d));    
    b = bitand(bitshift(repmat(d, size(shifts)), repmat(shifts, size(d))), 1);
    
  	%  ---------------- % 
    % Alternative approach 1, fastest 
    % 	switch lower(msbflag)
    % 		case 'left-msb'
    % 			aux = 2.^-(n-1:-1:0);
    % 		case 'right-msb'
    % 			aux = 2.^-(0:1:n-1);
    % 		otherwise
    % 			error('my_de2bi:wrongMSBflag', 'Unsupported value for MSBFLAG');
    % 	end
    % 	b = logical(rem(floor(kron(d, aux)), 2));
	
    %  ---------------- % 
	% Alternative approach 2
	% This implementation uses a less efficient approach (because of "for" loops), but may be easier to understand
	%
	% % Allocate space for output
	% b = zeros(length(d), n);
	%
	% % Convert to binary. Loop over the entries of d, and for each entry, first
	% % get the lsb, and then keep right shifting by dividing by 2 until the
	% % number is zero.
	% for k = 1:length(d)
    %	x = d(k);
    %	l = 1;      % Indicates the bit we are currently looking at
    %
    %	while (x > 0)
    %    
    %    	% Extract lsb, shift x to the right and update index
    %    	b(k, l) = bitand(x, 1);
    %   	x = bitshift(x,-1);
    %   	l = l + 1;
    %	end
	% end
	%
	% % If msbflag is 'left-msb', flip the bits left-to-right;
	% switch(msbflag)
    %	case 'left-msb'
    %	    b = fliplr(b);
    %	case 'right-msb'
    %	    % do nothing
    %	otherwise
    %	    error('my_de2bi:wrongMSBflag', 'Invalid value of MSBFLAG');
	%	end