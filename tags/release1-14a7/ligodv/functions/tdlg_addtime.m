function times = tdlg_addtime(handles)

% TDLG_ADDTIME add a time to the times structure.
% 
% M Hewitson 03-08-06
% 
% $Id$
% 

% get current times structure
times = getappdata(handles.main, 'times');

% get the entered times
startgps = str2num(get(handles.tdlg_gpsStart, 'String'));
stopgps  = str2num(get(handles.tdlg_gpsStop, 'String'));

% get entered comment
comment = get(handles.tdlg_comment, 'String');

% check for duplication
for j=1:times.ntimes
  
  ts = times.t(j);
  if  ts.startgps == startgps   && ...
      ts.stopgps  == stopgps    && ...
      strcmp(ts.comment, comment)
     
    ldv_disp('!!! time already exists in list; not adding.');
    return
    
  end
end

% add to times struct
times.ntimes = times.ntimes+1;
times.t(times.ntimes).startgps = startgps;
times.t(times.ntimes).stopgps  = stopgps;
times.t(times.ntimes).comment  = comment;

% END
