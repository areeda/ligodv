function ldv_setdobjslist(handles, dobjs, idx)

% LDV_SETDOBJSLIST set the contents of the dobjs list based on the dobjs
% structure app data.
% 
% M Hewitson 26-07-06
% 
% $Id$
% 

% dobjs = getappdata(handles.main, 'dobjs');
% maxstr = dv_dobjsmaxchannelname(dobjs);

objlist = [];

% build list of strings
try
  for j=1:dobjs.nobjs

    obj = dobjs.objs(j);

    dur    = obj.stopgps - obj.startgps;
    durstr = ldv_secs2timestr(dur);
    str    = sprintf('%02d: %s    %d    %s    %d', obj.id, durstr, obj.startgps, obj.channel, obj.data.fs);

    objlist = strvcat(objlist, str);

  end

  set(handles.dataObjects, 'String', objlist);
  set(handles.dataObjects, 'Value', idx);

  % set the number of objects display
  ldv_setnobjsdisplay(handles, dobjs);

  % display info about first object
  ldv_setdobjinfo(handles);
end

% END
