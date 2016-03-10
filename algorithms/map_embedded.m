function P=map_embedded(MAP)
% MAP_EMBEDDED computes the transition probability matrix of the phase 
% in a MAP, observed at arrival moments
% MAP:  Markovian arrival process to evaluate
%
% Copyright (c) 2012-2014, Imperial College London 
% All rights reserved.

P=inv(-MAP{1})*MAP{2};
end