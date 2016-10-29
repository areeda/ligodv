function tdlg_timeselect(handles)

% TDLG_TIMESELECT set the selected time object to the input fields.
% 
% M Hewitson
% 
% $Id$
% 


% get selected times
idx = get(handles.tdlg_timesList, 'Value');

% if we have only one
if length(idx) == 1

  % get the times objects
  times = getappdata(handles.main, 'times');
  
  ts = times.t(idx);
  
  % set fields
  set(handles.tdlg_gpsStart, 'String', num2str(ts.startgps));
  set(handles.tdlg_gpsStop, 'String', num2str(ts.stopgps));
  
  set(handles.tdlg_utcStart, 'String', ldv_gps2utc(ts.startgps));
  set(handles.tdlg_utcStop, 'String', ldv_gps2utc(ts.stopgps));
  
  set(handles.tdlg_comment, 'String', ts.comment);
  
  % set duration
  tdlg_setduration(handles);
  
end


% END
