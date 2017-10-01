function p = PolyDeg3(x,y)
% compute the coefficients of a third degree polynomial such that 
% p(x_i)=y_i

% we use x to form a matrix M, so that y=Mp
x = x(:); % making sure that xr is a column vector
M = [ones(4,1),x,x.^2,x.^3];
% then solve for p. 
y = y(:);
p= M\y;