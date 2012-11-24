function strout = dv_strexpand(str, N)

% DV_STREXPAND pads the input string with N blank spaces.
% 
% M Hewitson 27-07-06
% 
% $Id$
% 

strout = str;
l = length(str)
n = (N-l+1)
for j=1:n
  strout = [strout ' '];
end
  
length(strout)


% END