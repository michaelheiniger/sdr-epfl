clear all; close all; clc;

% satellite positions
pS1=[-1,6];
pS2=[5,7];

%distance between the satellite 1 and the receiver
d1=3;
%distance between the satellite 2 and the receiver
d2=5;

% write your code here
x1 = -1;
y1 = 6;
x2 = 5;
y2 = 7;

syms x y
eq1 = (x-x1)^2+(y-y1)^2==9;
eq2 = (x-x2)^2+(y-y2)^2==25;
[xs,ys] = solve(eq1, eq2, x, y);
double(xs)
double(ys)



% Hint: How to solve a system of equations with unknowns x,y:

%declare x,y as symbolic variables
%syms x y

% use solve instruction; in the example below the equations are x^2=1 and
% x+y+1=2
%[xs,ys]=solve(x^2==1, x+y+1==2, x, y)