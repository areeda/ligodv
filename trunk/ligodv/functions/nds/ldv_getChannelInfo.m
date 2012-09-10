function ldv_getChannelInfo(handles)

% LDV_GETCHANNELINFO get 1s of data objects from the specified input fields.
% 
% M Hewitson 09-11-06
% 
% $Id$


% which mode are we in?
dvmode = ldv_getselectionbox(handles.dvmode);

switch dvmode
  
  case 'NDS Server'
    
    % what type of data?
    dtype = ldv_getselectionbox(handles.gd_dataTypeSelect);
    % server
    server = ldv_getserver(handles);
    % port
    port = ldv_getport(handles);
    
    % get channels
    channels = ldv_getselectedchannels(handles);
    
    if size(channels,1) == 1
      
      % start time
      startgps = ldv_getstartgps(handles);
      times.ntimes = 1;
      times.t(1).startgps = startgps;
      times.t(1).stopgps  = startgps+1;
      times.t(1).comment  = '';

      % get data as objects
      newdobjs = ldv_getdata(handles, dtype,...
        server, port, ...
        times, channels);
      
      set(handles.channelList, 'TooltipString', sprintf('%s: fs=%d', channels, newdobjs.objs.data.fs));
      
    else
      
      set(handles.channelList, 'TooltipString', '');
      
    end
    
  case 'Frame File'
    
    %dv_getFrameDataObjects(handles);
    
    
  otherwise
    error('### unknown dataviewer mode');
end

