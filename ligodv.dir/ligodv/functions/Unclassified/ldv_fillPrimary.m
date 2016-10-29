function ldv_fillPrimary(handles, handle)

% LDV_FILLPRIMARY fill a primary channel selector. 
% 
% M Hewitson 10-08-06
% 
% $Id$
% 


% get selected objects
didx = ldv_getselecteddobjs(handles);

% get objects
dobjs = getappdata(handles.main, 'dobjs');


% build strings for list box
%  - string same as in dobj list

if dobjs.nobjs > 0

  objlist = [];
  % build list of strings
  for j=didx

    obj = dobjs.objs(j);

    dur    = obj.stopgps - obj.startgps;
    durstr = ldv_secs2timestr(dur);
    str    = sprintf('%02d: %s', obj.id, obj.channel);

    objlist = strvcat(objlist, str);
  end
  
  % fill list box
  set(handle, 'String', cellstr(objlist));
  set(handle, 'Value', 1);

end


% END