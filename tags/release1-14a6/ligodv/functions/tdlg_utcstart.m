function tdlg_utcstart(handles)

% Responds to utc start input callback.
% 
% Sets UTC and GPS start, UTC and GPS stop, and Nsecs fields based on their
% current values and the value enetered in UTC start.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

% get the time that was entered
startutcInput = get(handles.tdlg_utcStart, 'String');

% Check for + or - signs
pidx = findstr(startutcInput, '+');
midx = findstr(startutcInput, '-');
if length(pidx) == 1 || length(midx) == 1
  % we need the stop time
  stopgps = str2num(get(handles.tdlg_gpsStop, 'String'));
  % set start time
  if length(pidx) == 1;
    corr = 0;
  else
    corr = 0;
  end
  eval(sprintf('startgps = stopgps +%d %s;', corr, startutcInput));   
else
  startgps = ldv_utc2gps(startutcInput);
end

% set UTC times
startutc = ldv_gps2utc(startgps);
% set fields
set(handles.tdlg_utcStart, 'String', startutc);
set(handles.tdlg_gpsStart, 'String', num2str(startgps));


% END