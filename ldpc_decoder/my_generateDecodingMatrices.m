% function [SOCKET, MCT, MVT] = generateDecodingMatrices(H)
% This function computes the three matrices SOCKET, MCT and MVT
% starting from the parity check matrix H according to the following
% description:
% Input matrix H has dimensions M x N, where M is the number of check
% nodes and N is the number of variable nodes

% SOCKET: matrix of dimensions NEDGES x 2. NEDGES is the total
% number of ones in matrix H. For each edge there is a row in SOCKET: 
% the first column is the index of the corresponding variable node, 
% and the second one containes the index of the corresponding check node


% MCT: sparse matrix of dimensions M x NEDGES, needed to sum all incoming
% edges at check nodes. It will have value 1 in position (i,j) if 
% the j'th socket is connected to check node i 
% (otherwise it will have value 0).

% MVT: sparse matrix of dimensions N x NEDGES, needed to sum all incoming
% edges at variable nodes. It will have value 1 in position (i,j) if 
% the j'th socket is connected to variable node i

function [socket, Mct, Mvt] = my_generateDecodingMatrices(H)

[i,j,~] = find(transpose(H));
socket = [j, i];

indices_sockets = 1:length(j);
indices_check_nodes = i;

Mct = sparse(indices_check_nodes, indices_sockets, 1);

indices_variable_nodes = j;
Mvt = sparse(indices_variable_nodes, indices_sockets, 1);

end