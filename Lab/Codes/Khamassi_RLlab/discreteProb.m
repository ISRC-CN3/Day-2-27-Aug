function sample = discreteProb(p)
% Draw a random number using probability table p (column vector)
% Suppose probabilities p=[p(1) ... p(n)] for the values [1:n] are given, sum(p)=1 and the components p(j) are nonnegative. To generate a random sample of size m from this distribution imagine that the interval (0,1) is divided into intervals with the lengths p(1),...,p(n). Generate a uniform number rand, if this number falls in the jth interval give the discrete distribution the value j. Repeat m times.

r = rand;
cumprob=[0; cumsum(p)];
sample = -1;
for j=1:length(p)
  if (r>cumprob(j)) & (r<=cumprob(j+1))
    sample = j;
    break;
  end
end
