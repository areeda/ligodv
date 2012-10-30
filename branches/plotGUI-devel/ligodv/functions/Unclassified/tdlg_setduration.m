function tdlg_setduration(handles)

% TDLG_SETDURATION set the duration display based on the current start
% and stop times.
% 
% M Hewitson 26-07-06
% 
% $Id$
% 

% get start time and stop time
startgps = str2num(get(handles.tdlg_gpsStart, 'String'));
stopgps  = str2num(get(handles.tdlg_gpsStop, 'String'));

secs = stopgps - startgps;
if secs < 0
  tstr = '???';
else
  tstr = ldv_secs2timestr(secs);
end
set(handles.tdlg_duration, 'String', tstr);


% END