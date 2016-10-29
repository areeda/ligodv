function chansout = filtercontrolchans(channels)

% DV_FILTERCONTROLCHANS filter out control channels
% 
% M Hewitson 26-07-06
% 
% $Id$
% 

nchans = size(channels,1);
chansout = [];
for c=1:nchans
  idx = strfind(channels(c,:), '#');
  if isempty(idx)
    chansout = strvcat(chansout, deblank(channels(c,:)));
  end
end

chansout = char(sort(cellstr(chansout)));

% END