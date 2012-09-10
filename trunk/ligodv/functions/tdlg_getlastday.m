function times = tdlg_getlastday(handles)

% TDLG_GETLASTDAY get a set of times that span the day prior to the
% current entered time.
% 
% M Hewitson 03-08-06
% 
% $Id$
% 

% get current time list
times = getappdata(handles.main, 'times');

% get the current time
startgpsStr = get(handles.tdlg_gpsStart, 'String');
stopgpsStr  = get(handles.tdlg_gpsStop, 'String');

if ~isempty(startgpsStr) && ~isempty(stopgpsStr)
  
  % get entered time
  startgps = str2num(startgpsStr);
  stopgps  = str2num(stopgpsStr);
  dur      = stopgps - startgps;
  stop     = startgps - 86400;
  
  % 5 minute steps
  n = 1;
  while startgps >= stop
    
    % make new times object
    times.ntimes = times.ntimes + 1;
    times.t(times.ntimes).startgps = startgps;
    times.t(times.ntimes).stopgps  = startgps + dur;
    times.t(times.ntimes).comment  = sprintf('step %d', n);

    % loop
    startgps = startgps - 3600;
    n = n + 1;
  end
  
else
  
  ldv_disp('!!! enter a start and stop time first');
  
end


% END