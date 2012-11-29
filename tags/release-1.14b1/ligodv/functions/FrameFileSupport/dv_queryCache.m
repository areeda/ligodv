function dv_queryCache(handles)

% DV_QUERYCACHE query the file cache and get the latest time and a channel
% list.
% 
% M Hewitson 27-09-06
% 
% $Id$
% 

% get latest time
[earliest,latest] = dv_ff_getlatest(handles);
dv_setlatest(handles, latest);
%dv_setstartlatest(handles);
% set gps and utc start
set(handles.gpsStartInput, 'String', num2str(earliest));
set(handles.utcStartInput, 'String', dv_gps2utc(earliest));
dv_setstoplatest(handles);


% get channels
dv_getChannelList(handles);

% END