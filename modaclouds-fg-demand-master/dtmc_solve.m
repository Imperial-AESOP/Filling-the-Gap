function PROB=dtmc_solve(P)
% PROB=DTMC_SOLVE(Q) returns the the stationary probability vector PROB 
% of a discrete-time Markov chain with transition matrix P
%
%  Input:
%  P: transition matrix of the discrete-time Markov chain
%
%  Output:
%  PROB: equilibrium distribution of the discrete-time Markov chain
%
% Copyright (c) 2012-2014, Imperial College London 
% All rights reserved.

PROB=ctmc_solve(P-eye(size(P)));
end
