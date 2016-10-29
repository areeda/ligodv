function dv_duplicatedobjs(handles)

% DV_DUPLICATEDOBJS duplicate selected data objects.
% 
% M Hewitson 12-08-06
% 
% $Id$
% 

% get selected objects
didx  = ldv_getselecteddobjs(handles);
dobjs = getappdata(handles.main, 'dobjs');

% prepare output structure
sdobjs       = [];
sdobjs.nobjs = 0;

for idx=didx
 
  % get this object
  sdobjs.nobjs = sdobjs.nobjs+1;
  sdobjs.objs(sdobjs.nobjs) = dobjs.objs(idx);
  sdobjs.objs(sdobjs.nobjs).id = -idx;  % reset counter
end

% add objects and reset list
dobjs = ldv_dobjsunique(dobjs, sdobjs, handles);

% set list of objects
setappdata(handles.main, 'dobjs', dobjs);
ldv_setnobjsdisplay(handles, dobjs);
ldv_setdobjslist(handles, dobjs, didx);

% END