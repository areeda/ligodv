function [dtype, server, port, times, channels] = gui_getDataSpec( handles )
%GUI_GETDATASPEC Extract data object specifiers from the GUI
% input
%   handles - is the arguement from the GUIDE callback
% output:
%   dtype = nds1, nds2 ... from drop down
%   server, port - define where to get the data from
%   times is a list of all requested intervals in GPS seconds start, stop
%   channel is a list of channel names,type
%% ------------------------------------------------------------------------


  % what type of data?
  dtype = ldv_getselectionbox(handles.gd_dataTypeSelect);
  % server 
  server = ldv_getserver(handles);
  % port
  port = ldv_getport(handles);
  
  % list of times or single?
  if get(handles.timeListRB, 'Value')==1
    
    times = getappdata(handles.main, 'times');
    
  elseif get(handles.singleTimeRB, 'Value')==1
    % start time
    startgps = ldv_getstartgps(handles);
    % stop time
    stopgps = ldv_getstopgps(handles);  
    
    times.ntimes = 1;
    times.t(1).startgps = startgps;
    times.t(1).stopgps  = stopgps;
    times.t(1).comment  = ldv_getcomment(handles);
    
  else
    error('### wrong time source selection')
  end
  
  % get channels
  channels = ldv_getselectedchannels(handles);
  
end


