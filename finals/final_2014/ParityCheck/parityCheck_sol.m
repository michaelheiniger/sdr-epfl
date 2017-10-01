clear all; close all; clc;



% generate the data
m=[1 1 1 1 0 0 1 ;...
   1 0 0 0 1 0 0;...
   0 0 1 1 0 1 1;...
   0 1 1 0 1 0 1];

p=[1; 0; 1; 0];

bits=[m,p];
bits=bits';
%save bits bits


%solution

clear all; close all; clc;

load bits

parResult=mod(sum(bits)+1,2)


%or, step by step:
dataBits=bits(1:end-1,:);
calcPar=mod(sum(dataBits),2);
parBits=bits(end,:);

parResult=ones(size(parBits));
parResult(find(calcPar-parBits))=0






 