function ldv_utcstop(handles)

% Responds to utc stop input callback.
% 
% Sets UTC and GPS start, UTC and GPS stop, and Nsecs fields based on their
% current values and the value enetered in UTC stop.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

% get the time that was entered
stoputcInput = get(handles.utcStopInput, 'String');

% Check for + or - signs
pidx = findstr(stoputcInput, '+');
midx = findstr(stoputcInput, '-');
if length(pidx) == 1 || length(midx) == 1
  % we need the start time
  startgps = str2num(get(handles.gpsStartInput, 'String'));
  % set stop time
  if length(pidx) == 1;
    corr = 0;
  else
    corr = 0;
  end
  eval(sprintf('stopgps = startgps + %d %s;', corr, stoputcInput));   
else
  stopgps = ldv_utc2gps(stoputcInput);
end

% set UTC times
stoputc = ldv_gps2utc(stopgps);
% set fields
set(handles.utcStopInput, 'String', stoputc);
set(handles.gpsStopInput, 'String', num2str(stopgps));

% END
