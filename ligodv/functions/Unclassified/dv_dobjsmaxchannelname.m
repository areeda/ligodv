function maxstr = dv_dobjsmaxchannelname(dobjs)

% DV_DOBJSMAXCHANNELNAME returns the length of the longest channel name in
% the set of data objects.
% 
% M Hewitson
% 
% $Id$
% 

maxstr = 0;
for j=1:dobjs.nobjs
  
  l = length(deblank(dobjs.objs(j).channel));
  if l > maxstr
    maxstr = l;
  end
  
end


% END