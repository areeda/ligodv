function ldv_setdatatype(handles)

% LDV_SETDATATYPE set the relevant gui elements for the chosen data
% type. 
% 
% This is for LIGO Server mode.
% 
% M Hewitson 24-07-06
% 
% $Id$
% 

% We select here which panel to display
pstr  = ldv_getselectionbox(handles.gd_dataTypeSelect);

switch pstr
      
  % raw data files
    
  case {'raw data','rds'}
    
    setstate(handles.gd_portInputTxt, 'on');    % switch on port field
    setstate(handles.gd_rdslevel, 'off');       % switch off rds input
    setstate(handles.gd_calversion, 'off');     % switch off cal input
    setstate(handles.gd_stat, 'off');           % switch off stat input
    
    case {'second trends', 'minute trends'}  
    setstate(handles.gd_portInputTxt, 'on');    % switch on port field
    setstate(handles.gd_rdslevel, 'off');       % switch off rds input
    setstate(handles.gd_calversion, 'off');     % switch off cal input
    setstate(handles.gd_stat, 'on');           % switch on stat input    
    
  otherwise
    error('Unknown data type')
end

end


% END

function setstate(handle, state)

  switch state
    case 'on'
      set(handle, 'enable', 'on');
      set(handle, 'BackgroundColor', 'w');
      
    case 'off'
      set(handle, 'enable', 'off');
      set(handle, 'BackgroundColor', [0.9 0.9 0.9]);
      
    otherwise
      error('unknown state for object');
  end

end

