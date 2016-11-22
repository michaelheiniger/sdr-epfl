function [constellation] = my_mapper(M)



% Verify that M is the square of a power of two
if log2(sqrt(M)) ~= fix(log2(sqrt(M)))
    error('M must be in the form of M = 2^(2K), where K is a positive integer.');
end

%create the constellation

aux = (-(sqrt(M)-1):2:sqrt(M)-1);
[x, y] = meshgrid(aux, fliplr(aux));
c = x + 1i*y;
% We reshape c to be a row vector
constellation = transpose(c(:));
%Generate the unit-norm constellation
constellation = constellation/norm(constellation); %./ sqrt(mean(abs(constellation).^2));
sqrt(mean(abs(constellation).^2))
norm(constellation)
end