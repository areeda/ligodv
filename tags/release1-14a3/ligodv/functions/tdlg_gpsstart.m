function tdlg_gpsstart(handles)


% Responds to gps start input callback.
% 
% Sets UTC and GPS start, UTC and GPS stop, and Nsecs fields based on their
% current values and the value enetered in GPS start.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

% get the time that was entered
startgpsInput = get(handles.tdlg_gpsStart, 'String');

% Check for + or - signs
pidx = findstr(startgpsInput, '+');
midx = findstr(startgpsInput, '-');
if length(pidx) >= 1 || length(midx) >= 1
  % we need the stop time
  stopgps = str2num(get(handles.tdlg_gpsStop, 'String'));
  % set start time
  if length(pidx) == 1;
    corr = 0;
  else
    corr = 0;
  end

  eval(sprintf('startgps = stopgps +%d %s;', corr, startgpsInput)); 
  
else
  startgps = str2num(startgpsInput);
end

% set UTC times
startutc = ldv_gps2utc(startgps);
% set fields
set(handles.tdlg_utcStart, 'String', startutc);
set(handles.tdlg_gpsStart, 'String', num2str(startgps));

% END
