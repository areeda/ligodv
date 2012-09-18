function ldv_clearFilters(handles)

% LDV_CLEARFILTERS clears the filter objects from the selected data objects.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get data objects
didx  = ldv_getselecteddobjs(handles);
dobjs = getappdata(handles.main, 'dobjs');

% loop through selected objects
for idx=didx
  
  dobjs.objs(idx).filters.nfilts = 0;
  dobjs.objs(idx).filters.filts  = [];
  
end

% set objects again
setappdata(handles.main, 'dobjs', dobjs);
% update list
ldv_setnobjsdisplay(handles, dobjs);
ldv_setdobjslist(handles, dobjs), didx(1);

% END