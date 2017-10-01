function [socket,Mv] = p3(H)

% function [SOCKET] = p3(H)
% This function computes the matrix SOCKET
% starting from the parity check matrix H according to the following
% description:

% Input matrix H has dimensions M x N, where M is the number of check
% nodes and N is the number of variable nodes

% SOCKET: matrix of dimensions NEDGES x 2. NEDGES is the total
% number of ones in matrix H. For each edge there is a row in SOCKET: 
% the first column is the index of the corresponding variable node, 
% and the second one containes the index of the corresponding check node

% MV: sparse matrix of dimensions N x NEDGES, needed to sum all incoming
% edges at variable nodes. It will have value 1 in position (i,j) if 
% the j'th socket is connected to variable node i

M = size(H,1);
N = size(H,2);

[i,j,~] = find(transpose(H));

% Socket matrix
socket = [i,j];

% Mv
rows_mv = socket(:,1);
cols_mv = 1:length(socket);
Mv = sparse(rows_mv, cols_mv, 1, N, length(i));


% % Number of variable nodes and check nodes
% [~, nvars] = size(H);
% % Compute socket (it specifies the edges between variable and check nodes)
% [z, k] = find(H');
% socket = [z,k];
% nedges = length(z); % total number of edges between variable and check nodes
% % compute Mv
% Mv = sparse(socket(:,1), 1:nedges, ones(1,nedges), nvars, nedges);




