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

function H = my_makeh(Hcols)

%m = max(max(Hcols))+1;
%n = size(Hcols,1);

Hcols = transpose(Hcols);
i = reshape(Hcols(:), 1, numel(Hcols))+1;
j = kron(1:length(Hcols), [1,1,1]);
s = ones(1, numel(Hcols));

% H = sparse(i,j,s,m,n);
H = sparse(i,j,s);

end
