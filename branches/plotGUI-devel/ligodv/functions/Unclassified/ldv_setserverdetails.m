function ldv_setserverdetails(handles)

% LDV_SETSERVERDETAILS set the server and port fields based on the drop-down
% menu selection.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 


% set the server field
serverport     = ldv_getselectionbox(handles.gd_serverSelect);


[server, r] = strtok(serverport, ':');
port = strrep(r, ':', '');
set(handles.gd_serverInputTxt, 'String', server);
set(handles.gd_portInputTxt, 'String', port);


% ENDget