% clear all; close all; clc

load H_exam;

% (a) Compute the code rate

[m,n] = size(H);
code_rate= (n-m)/n;

% (b) Determine the value of g

ind = find(H(:,end), 1); % Determine first non-zero entry in last column of H
g = m - ind;


% (c) Compute the column description

[z, k] = find(H);

%compute the distribution of check nodes
number_of_checks_per_col = hist(k,n); 
number_of_checks_per_col_2 = sum(H);

% Initialize Hcol
Hcol=nan(max(k),max(number_of_checks_per_col));

% initial condition 
temp_col=k(1); % current column 
temp_counter_checks =0; % counter of the checks node in the current column

for i=1:length(z) % for each edge
    if (temp_col==k(i)) %same column 
        temp_counter_checks = temp_counter_checks +1;
    else % new column 
        temp_counter_checks = 1;
        temp_col =k(i);
    end
    Hcol(k(i),temp_counter_checks)=z(i); % write the position of the 1.
end
Hcol



