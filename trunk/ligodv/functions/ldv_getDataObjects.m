function ldv_getDataObjects(handles)

% LDV_GETDATAOBJECTS Get data Objects
%
% M Hewitson 28-09-06
% 
% $Id$
% 

  % get the settings
  [dtype, server, port, times, channels] = gui_getDataSpec(handles);
  
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





