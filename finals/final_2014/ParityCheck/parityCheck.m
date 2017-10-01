clear all; close all; clc;

% load the data bits
load bits


% compute and display the parity check result

parityResult = not(mod(sum(bits,1),2));