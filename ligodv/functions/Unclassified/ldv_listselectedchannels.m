function ldv_listselectedchannels(handles)

% LDV_LISTSELECTEDCHANNELS list the selected channels to the terminal.
% 
% M Hewitson 26-07-06
% 
% $Id$
% 

channels = ldv_getselectedchannels(handles);


start_time = ldv_getstartgps(handles);

ldv_disp(' ');
ldv_disp('-----------------------');
ldv_disp('   selected channels   ');
ldv_disp('-----------------------');
for j=1:size(channels, 1)
  
  % get one second of data for this channel and time
  
  
  ldv_disp('%02d  %s', j, channels(j,:))
  
end


% END