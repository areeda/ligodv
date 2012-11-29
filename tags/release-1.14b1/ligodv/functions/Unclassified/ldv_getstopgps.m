function stopgps = ldv_getstartgps(handles)

% LDV_GETSTOPGPS get the gps stop time from the input box.
% 
% M Hewitson 26-07-06
% 
% $Id$

str = get(handles.gpsStopInput, 'String');

if isempty(str)
  stopgps = -1;
else
  stopgps = str2num(str);
end

% END