clear all; close all; clc;

pS1=[-1,6];
pS2=[5,7];

d1=3;
d2=5;

syms px py

%[posx, posy]=solve((pS1(1)-px)^2+(pS1(2)-py)^2==d1^2,...
%    (pS2(1)-px)^2+(pS2(2)-py)^2==d2^2, px, py)

eq1=(pS1(1)-px)^2+(pS1(2)-py)^2==d1^2;
eq2=(pS2(1)-px)^2+(pS2(2)-py)^2==d2^2;
[posx, posy]=solve(eq1, eq2, px, py);

double([posx, posy])

% How to solve a system of equations with unknowns x,y:

%declare x,y as symbolic variables
%syms x y

% use solve instruction; in the example below the equations are x^2=1 and
% x+y+1=2
%[xs,ys]=solve(x^2==1, x+y+1==2, x, y)


