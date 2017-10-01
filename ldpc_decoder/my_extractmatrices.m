% EXTRACTMATRICES Extract submatrices from a sparse matrix for LPDC
% encoding
% [A, B, C, D, E, T, g, m, n] = EXTRACTMATRICES(H) returns
% submatrices A-E, T, as defined in "Efficient Encoding of
% Low-Density Parity Check Codes" (Richardson and Urbanke, 2001).
% The variables g, m, n contain the dimensions of the various
% submatrices as defined in the paper. It is assumed that H is
% already in the right form, with T being a lower triangular
% matrix.

function [A, B, C, D, E, T, g, m, n] = extractmatrices(H)

% Determine dimensions of H
[m,n] = size(H);

% Determine first non-zero entry in last column of H
ind = find(H(:,end), 1);
if isempty(ind)
    error('extractmatrices:allzeroLastCol', 'No 1s found in last column of H');
end
g = m - ind;

% Extract submatrices
A = H(1:m-g, 1:n-m);
B = H(1:m-g, n-m+1:n-m+g);
T = H(1:m-g, n-m+g+1:end);
C = H(m-g+1:end, 1:n-m);
D = H(m-g+1:end, n-m+1:n-m+g);
E = H(m-g+1:end, n-m+g+1:end);

%% Sanity checks
% 1. Check dimensions
[mm, nn] = size([A B T; C D E]);
if any([mm, nn] ~= [m, n])
    error('extractmatrices:inconsistentDimensions', 'Dimensions of submatrices not consistent');
end

% 2. Check that T is indeed lower triangular
if any((T-tril(T)) ~= 0)  %if (norm((T-tril(T))) ~= 0)
    error('extractmatrices:TnotTriangular', 'T turns out not to be triangular!!');
end
