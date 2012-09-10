function ldv_setstoplatest(handles)

% LDV_SETSTOPLATEST set the latest time as the stop time.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

% get latest from GPS latest field
latest = str2num(get(handles.gpsLatest, 'String'));

% set gps and utc stop
set(handles.gpsStopInput, 'String', num2str(latest));
set(handles.utcStopInput, 'String', ldv_gps2utc(latest));

ldv_setdurationdisp(handles);

% END