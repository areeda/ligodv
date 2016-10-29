function startgps = ldv_getstartgps(handles)

% LDV_GETSTARTGPS get the gps start time from the input box.
% 
% M Hewitson 26-07-06
% 
% $Id$

str = get(handles.gpsStartInput, 'String');

if isempty(str)
  startgps = -1;
else
  startgps = str2num(str);
end

% END