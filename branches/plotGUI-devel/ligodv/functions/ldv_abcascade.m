function [ao,bo] = ldv_abcascade(a1,b1,a2,b2)

% LDV_ABCASCADE Cascade two filters together to get a new filter.
% 
% usage: [a,b] = ldv_abcascade(a1,b1,a2,b2)
% 
% M Hewitson 03-04-07
% 
% $Id$
% 

n = length(a1);
m = length(a2);
N = m+n-1;

alpha = zeros(1, N);
beta = zeros(1, N);

for i=0:n-1
  for j=0:m-1
    alpha(i+j+1) = alpha(i+j+1) + a1(i+1)*a2(j+1);
    beta(i+j+1) = beta(i+j+1) + b1(i+1)*b2(j+1);            
  end
end

ao = alpha;
bo = beta;