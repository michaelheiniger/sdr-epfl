function [ Z ] = my_demodulator( Y, MAP )
% MY_DEMODULATOR Minimum distance slicer
% Z = MY_DEMODULATOR(Y, MAP) demodulates vector Y
% by finding the element of the specified constellation that is
% closest to each element of input Y. Y contains the outputs of
% the matched filter of the receiver, and it can be a row or
% column vector. MAP specifies the constellation used, it can
% also be a row or column vector.
% Output Z has the same dimensions as input Y.
% The elements of Z are M-ary symbols, i.e., integers between
% 0 and M=length(MAP)-1.

% Check row/column vector for Y
[rows, cols] = size(Y);
transpose = 0;
if cols == 1
   transpose = 1;
   Y = Y.'; % .' is the NON-CONJUGATE tranpose... (duhh !)
end

M = length(MAP);
length_Y = length(Y);
Y_rep = repmat(Y.',1,M); % .' is the NON-CONJUGATE tranpose... (duhh !)
MAP_rep = repmat(MAP, length_Y, 1);

% Compute distances
distances = euclidean_distance(Y_rep, MAP_rep);

[values, indice] = min(distances, [], 2);

Z = indice-1; %Since MAP values are from 0 and not 1

if transpose
    Z = Z';
end

function distances = euclidean_distance(v1, v2)
     distances = sqrt((v1-v2).*(v1-v2));
end

end

