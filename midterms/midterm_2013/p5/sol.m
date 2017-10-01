% SDR 2013 midterm - Problem 5
clear all;close all;clc;
%the number of transmitted symbols (not including the training sequence)
nSymbols=1000;
% load the training sequence, named traninig
load training;
%load the received signal containing the delay, the training symbols and
%the modulation symbols
load received
% (a) estimate the start of the QAM symbol sequence in the received data and the
%rotation
corrResult=xcorr(received, training);
corrResult(1:length(received)-1)=[];
%start position of the training sequence
[M, pos]=max(abs(corrResult));
pos
%start position of the QAM symbols
startPos=pos+length(training);
%estimate the rotation angle
rTraining=received(pos:pos+length(training)-1);
estimRotation=mean(rTraining./training);
phase(estimRotation)
% (b) pull out the noisy symbol sequence and correct for the phase rotation
rSymbols=received(startPos:startPos+nSymbols-1);
rSymbolsCorrected=rSymbols*estimRotation';
% (c) plot the complex plane noisy symbols
scatterplot(rSymbols), title ('before rotation correction')
scatterplot(rSymbolsCorrected), title ('after rotation correction')
% (d) decode the bit sequence
l = 8;
% rSymbolsCorrected(l)
bitsREstimated=sign(real(rSymbolsCorrected));
% bitsREstimated(l)
bitsIEstimated=sign(imag(rSymbolsCorrected));
% bitsIEstimated(l)
% you can compare the result with the bit sequences stored in bitsR.mat
% and bitsI.mat
load bitsR
load bitsI
errR=nnz(bitsR-bitsREstimated);
errI=nnz(bitsI-bitsIEstimated);