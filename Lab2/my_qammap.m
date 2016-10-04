function [ C ] = my_qammap( M )
% MY_QAMMAP Creates constellation for square QAM modulations
% C = MY_QAMMAP(M) outputs a 1×M vector with the
% constellation for the quadrature amplitude modulation of
% alphabet size M, where M is the square of an integer power
% of 2 (e.g. 4, 16, 64, ...).
% The signal constellation is a square constellation.


% Check if M is the square of a power of 2 (required for a QAM, by definition)
if (not(is_number_integer(log2(sqrt(M)))) || M <= 1)
    error('M must be the square of a power of 2.');
end

% Computes the values of the points of the constellation that are farthest 
% from the center
max_coordinate = sqrt(M)-1;

% Computes the grid containing the constellation points 
% (space between 2 points is 2 in both real and imaginary axis)
[Y,X] = ndgrid(max_coordinate:-2:-max_coordinate,-max_coordinate:2:max_coordinate);

% Combining the two parts of the grid
QAM = X + 1i*Y;

% Return the grid as a vector
C = reshape(QAM, 1, M);

function result = is_number_integer(n)
    result = (mod(n,1) == 0);
end
end

