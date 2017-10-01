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
function [z] = my_demodulator(y, map)

% Check the format of y
[rows, ~] = size(y);

y_row = (rows == 1);
if y_row == 1
   % y is a row vector
   y = transpose(y); % y becomes a column vector
end

% Compute the distance for each pair (yi,mapi)
matrix_y = repmat(y, 1, length(map));
matrix_map = repmat(map, length(y), 1);

% Minimum distance over the second dimensions
% The indices correspond to map values + 1
[~, indices] = min(abs(matrix_y-matrix_map), [], 2);

% Offset by -1 to be in {0,1,...,M-1}
z = indices-1;

% Transpose if needed
if y_row == 1
   z = transpose(z); % z becomes a row vector
end

end

