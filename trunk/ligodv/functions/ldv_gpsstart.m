function ldv_gpsstart(handles)


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
startgpsInput = get(handles.gpsStartInput, 'String');

% Check for + or - signs
pidx = findstr(startgpsInput, '+');
midx = findstr(startgpsInput, '-');
nonint = findstr(startgpsInput, '.');
if length(nonint) >= 1
  % round the time up or down
  startgpsInput = str2num(startgpsInput);
  modu = mod(startgpsInput,1);
  if modu >= .5
      startgpsInput = startgpsInput + (1 - modu);
  else 
      startgpsInput = startgpsInput - modu;
  end  
  startgpsInput = num2str(startgpsInput);
end
if length(pidx) >= 1 || length(midx) >= 1
  % we need the stop time
  stopgps = str2num(get(handles.gpsStopInput, 'String'));
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
set(handles.utcStartInput, 'String', startutc);
set(handles.gpsStartInput, 'String', num2str(startgps));

% END
