% MAKEH Create a binary sparse parity check matrix for an LDPC code
% 	starting from its column description
%   H = MAKEH(Hcols) returns a sparse matrix H for an LDPC code. 
%   The input matrix Hcols describes the locations of the 1s of H;
%   more specifically, the fist row of Hcols lists the position of
%   the 1s of the first column of H, the second row of Hcols lists
%   the position of the 1s of the second column of H, etc. 
%   (Notice that the elements of Hcols are 0-based indices, while 
%    Matlab indices are 1-based)
%   The resulting H is an m x n matrix, where n is the number 
%   of rows of Hcols and m equals the largest component of 
%   Hcols (plus one, since indices are 0-based). 
%   H should be a Matlab sparse matrix in order to avoid 
%   wasting memory. 

function H = makeh(Hcols)

% Obtain dimensions of parity check matrix
n = size(Hcols, 1);         % number of variable nodes, i.e., number of columns of H
m = max(max(Hcols)) + 1;    % number of check nodes, i.e, number of rows of H


    % First approach:simplistic for loop
    % H = sparse(m, n);
    % for k = 1:n
    %     H(Hcols(k,:) + 1, k) = 1;
    % end

% Second approach (and much more efficient method)
aux = transpose(Hcols); 
rows = aux(:)+1;
columns = kron(1:n, ones(1, size(Hcols, 2)));
values = ones(1, numel(Hcols)); 

% We could use true() instead of ones() so that the elements of the matrix are logicals and saves a factor a 8 in memory
% But this would cause problems later on in the decoder, since the multiplication of matrices of logicals is not defined in Matlab
% (The multiplication of logical scalars is however well defined)
H = sparse(rows, columns, values, m, n); 
