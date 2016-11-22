% function [estim_tx_bits] = my_demapper(r,constellation).
% It finds the maximum likelihood symbol sequence that corresponds to the received (noisy) sequence
% r and it outputs the corresponding bit sequence

function [estim_tx_bits] = my_demapper(r,constellation)


% r is column-vector
r =  transpose(r);

r_repeat = repmat(r, 1, length(constellation));
map_repeat = repmat(constellation, length(r), 1);

[~, indices] = min(abs(r_repeat - map_repeat), [], 2);

dec = indices-1;

estim_tx_bits = de2bi(dec);


end