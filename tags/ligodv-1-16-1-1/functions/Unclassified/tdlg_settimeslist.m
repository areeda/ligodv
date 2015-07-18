function tdlg_settimeslist(handles)

% TDLG_SETTIMESLIST set the times list to the contents of the times
% structure.
% 
% M Hewitson 03-08-06
% 
% $Id$
% 

% get times structure
times = getappdata(handles.main, 'times');

% set the list 
timesstr = [];
for n=1:times.ntimes
      
  % get this time
  ts       = times.t(n);
  startgps = ts.startgps;
  stopgps  = ts.stopgps;
  comment  = ts.comment;
  dur      = stopgps-startgps;
  durstr   = ldv_secs2timestr(dur);
  
  % build display string
  tstr = sprintf('%s   %s   %s', ldv_gps2utc(startgps), durstr, comment);
  timesstr = strvcat(timesstr, tstr);  
  
end

if times.ntimes == 0
  set(handles.tdlg_timesList, 'String', '  ');
else
  set(handles.tdlg_timesList, 'String', timesstr);
end
set(handles.tdlg_timesList, 'Value', 1);



% END
