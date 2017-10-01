% clear all; close all; clc;

load H_exam;

% (a) Compute the code rate
[i,j,~] = find(H);

codeword_length = size(H,2);
number_information_bit = 1;

code_rate = codeword_length / number_information_bit;

% (b) Determine the value of g
m = size(H,1);

% g = m-(m-g)
g = m - find(H(:,end), 1, 'first');

% (c) Compute the column description
n = size(H,2);
[c, ~] = max(sum(full(H),1));
Hcols = nan(n,c);

for i = 1:length(H)
    [rows, ~,~] = find(H(:,i));
    Hcols(i,:) = [transpose(rows), nan(1,c-length(rows))];
end

Hcols
