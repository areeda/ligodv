function ldv_gpsstop(handles)

% Responds to gps stop input callback.
% 
% Sets UTC and GPS start, UTC and GPS stop, and Nsecs fields based on their
% current values and the value enetered in GPS stop.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

% get the time that was entered
stopgpsInput = get(handles.gpsStopInput, 'String');

% Check for + or - signs
pidx = findstr(stopgpsInput, '+');
midx = findstr(stopgpsInput, '-');
nonint = findstr(stopgpsInput, '.');
if length(nonint) >= 1
  % round the time up or down
  stopgpsInput = str2num(stopgpsInput);
  modu = mod(stopgpsInput,1);
  if modu >= .5
      stopgpsInput = stopgpsInput + (1 - modu);
  else 
      stopgpsInput = stopgpsInput - modu;
  end  
  stopgpsInput = num2str(stopgpsInput);
end
if length(pidx) >= 1 || length(midx) >= 1   
  % we need the start time
  startgps = str2num(get(handles.gpsStartInput, 'String'));
  % set stop time
  if length(pidx) == 1;
    corr = 0;
  else
    corr = 0;
  end

  eval(sprintf('stopgps = startgps +%d %s;', corr, stopgpsInput)); 
  
else
  stopgps = str2num(stopgpsInput);
end

% set UTC times
stoputc = ldv_gps2utc(stopgps);
% set fields
set(handles.utcStopInput, 'String', stoputc);
set(handles.gpsStopInput, 'String', num2str(stopgps));

% END
