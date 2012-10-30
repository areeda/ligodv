function [x, y, fs] = ldv_matchvectors(x, xfs, y, yfs)

% LDV_MATCHVECTORS make the two vectors have the same length and sample rate
% by resampling the one with the lower samplerate then truncating the
% longer.  
% 
% M Hewitson 25-09-06
% 
% $Id$
% 

% check the sample rates
if yfs > xfs
  ldv_disp('!!! vectors are not equal sample rates. Down-sampling y. !!!');
  y = resample(y, xfs, yfs);
  fs = xfs;
end

if xfs > yfs
  ldv_disp('!!! vectors are not equal sample rates. Down-sampling x. !!!');
  x = resample(x,yfs,xfs);
  fs = yfs;
end

if xfs == yfs
  fs = xfs;
end

% now check the vector lengths
nx = length(x);
ny = length(y);

if nx > ny
  ldv_disp('!!! vectors are not equal lengths. Truncating x. !!!');
  x = x(1:ny);
end
if ny > nx
  ldv_disp('!!! vectors are not equal lengths. Truncating y. !!!');
  y = y(1:nx);
end



% END