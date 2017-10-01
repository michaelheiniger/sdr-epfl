function p = PolyDeg3(x,y)
% compute the coefficients of a third degree polynomial such that 
% p(x_i)=y_i

p = [p0,p1,p2,p3];

x = x(:);
B = y(:);

A = [ ones(4, 1), x, x.^2, x.^3 ];

p = A \ B;

end
