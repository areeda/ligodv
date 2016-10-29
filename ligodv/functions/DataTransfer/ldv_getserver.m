
function server = ldv_getserver(handles)

% LDV_GETSERVER get the server name from the server input field.
% 
% M Hewitson 26-07-06
% 
% $Id$
% 

server = get(handles.gd_serverInputTxt, 'String');


% END