function [H, Mc, Mv]=generateMatrices(socket)

% function [H, MC, MV] = generateMatrices(SOCKET)
% This function computes the three matrices H, MC and MV
% starting from the socket SOCKET according to the following
% description:
% SOCKET: matrix of dimensions NEDGES x 2. NEDGES is the total
% number of ones in matrix H. For each edge there is a row in SOCKET: 
% the first column contains the index of the corresponding variable node, 
% and the second column containes the index of the corresponding check node

% H is the sparse parity check matrix. It has dimensions M x N, where M is the 
% number of check nodes and N is the number of variable nodes. It has a 1
% in position (i,j) if variable j is connected to check node i.

% MC: sparse matrix of dimensions M x NEDGES, needed to sum all incoming
% edges at check nodes. It will have a value 1 in position (i,j) if 
% the j'th edge in matrix socket is connected to check node i 
% (otherwise it will have a value of 0).

% MV: sparse matrix of dimensions N x NEDGES, needed to sum all incoming
% edges at variable nodes. It will have a value 1 in position (i,j) if 
% the j'th edge in matrix socket is connected to variable node i


%determine number of edges
N_edge = size(socket, 1);

%determine H
i = socket(:,2); % Indices of check nodes
j = socket(:,1); % Indices of variable nodes

H = sparse(i, j, 1);

%determine Mc
i = socket(:,2); % Check nodes
j = 0:length(socket); % Socket indices

Mc = sparse(i, j, 1);

%determine Mv
i = socket(:,1); % Var nodes
j = 0:length(socket); % Socket indices

Mv = sparse(i, j, 1);
