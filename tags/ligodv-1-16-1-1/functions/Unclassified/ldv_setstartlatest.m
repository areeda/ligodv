function ldv_setstartlatest(handles)

% LDV_SETSTARTLATEST set the latest time as the start time.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

% get latest from GPS latest field
latest = str2num(get(handles.gpsLatest, 'String'));

% set gps and utc start
set(handles.gpsStartInput, 'String', num2str(latest-1));
set(handles.utcStartInput, 'String', ldv_gps2utc(latest-1));

ldv_setdurationdisp(handles);


% END