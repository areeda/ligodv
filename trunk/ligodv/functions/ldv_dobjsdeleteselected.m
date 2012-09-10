function ldv_dobjsdeleteselected(handles)

% LDV_DOBJSDELETESELECTED delete the selected data objects from the internal
% structure and redisplay the list.
% 
% M Hewitson 27-07-06
% 
% $Id$

% get selected objects
dobjsidx = get(handles.dataObjects, 'Value');

% get the full object structure
dobjs = getappdata(handles.main, 'dobjs');

% prepare a new set of objects
dobjsout.objs    = [];
dobjsout.nobjs   = 0;
dobjsout.counter = dobjs.counter;

% copy those not selected
for j=1:dobjs.nobjs
  if j~=dobjsidx
    dobjsout.objs  = [dobjsout.objs dobjs.objs(j)];
    dobjsout.nobjs = dobjsout.nobjs + 1;
  end
end

% set data
setappdata(handles.main, 'dobjs', dobjsout);
ldv_setnobjsdisplay(handles, dobjsout);
ldv_setdobjslist(handles, dobjsout, 1);




% END