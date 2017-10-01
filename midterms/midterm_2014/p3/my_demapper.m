% function [estim_tx_bits] = my_demapper(r,constellation).
% It finds the maximum likelihood symbol sequence that corresponds to the received (noisy) sequence
% r and it outputs the corresponding bit sequence

function [estim_tx_bits] = my_demapper(r,constellation)


r = r(:);

repr = repmat(r, 1, length(constellation));
repconst = repmat(constellation, length(r), 1);

distances = abs(repr-repconst);

[~, indices] = min(distances, [], 2);
estim_tx_bits = transpose(de2bi(indices-1));
estim_tx_bits = estim_tx_bits(:);




end