function ldv_settimepanel(handles)

% LDV_SETTIMEPANEL setup the time panel for the selected input mode.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

% get selected value
timemode  = ldv_getselectionbox(handles.timeInputMode);

switch timemode
  case 'UTC'
    
    set(handles.utcPanel, 'Visible', 'on');
    set(handles.gpsPanel, 'Visible', 'off');
    
    
  case 'GPS'
    
    set(handles.utcPanel, 'Visible', 'off');
    set(handles.gpsPanel, 'Visible', 'on');
    
  otherwise
    error('### unknown time input mode');
end


% END