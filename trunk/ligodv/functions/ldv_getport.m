function port = ldv_getport(handles)

% LDV_GETPORT get the port from the port input field.
% 
% M Hewitson 26-07-06
% 
% $Id$
% 

portstr = get(handles.gd_portInputTxt, 'String');
if isempty(portstr)
  port = 0;
else
  port = str2num(portstr);
end

% END