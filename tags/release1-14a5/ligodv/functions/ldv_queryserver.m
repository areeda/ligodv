function ldv_queryserver(handles)

% LDV_QUERYSERVER query the server for latest time and channel list.
% 
% M Hewitson 27-07-06
% 
% $Id$
% 

% get latest time
%latest = ldv_getlatest(handles);
%ldv_setlatest(handles, latest);
%ldv_setstartlatest(handles);
%ldv_setstoplatest(handles);


% get channels
ldv_getChannelList(handles);


% END
