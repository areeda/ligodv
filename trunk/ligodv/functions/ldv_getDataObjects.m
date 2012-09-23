function ldv_getDataObjects(handles)

% LDV_GETDATAOBJECTS Get data Objects
%
% M Hewitson 28-09-06
% 
% $Id$
% 

  % get the settings
  [dtype, server, port,...
      times, channels] = getsettings(handles);
  
  % get data objects
  newdobjs = ldv_getdata(handles, dtype,...
                            server, port,...
                            times, channels);
                      
                          
  % get existing dobjs
  dobjs = getappdata(handles.main, 'dobjs');
  try
    didx  = ldv_getselecteddobjs(handles);
  catch
    didx = [];
  end
  if isempty(didx)
    didx = 1;
  end
  
  % we should check for any objects that are duplicated
  % before adding them to the existing list.
  % !!! Better would be to do this _before_ getting the data
  %     Something for v2 !!!
  %   
  dobjs = ldv_dobjsunique(dobjs, newdobjs, handles);
  
  % set list of objects
  setappdata(handles.main, 'dobjs', dobjs);
  ldv_setnobjsdisplay(handles, dobjs);
  ldv_setdobjslist(handles, dobjs, didx(didx<dobjs.nobjs));
  drawnow;  % make sure the new objects are shown
end





%% ------------------------------------------------------------------------
function [dtype, server, port, times, channels]...
            = getsettings(handles)
% Get the settings for data


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

