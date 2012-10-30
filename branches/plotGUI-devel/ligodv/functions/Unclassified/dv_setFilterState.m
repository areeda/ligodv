function dv_setFilterState(handles, state)

% DV_SETFILTERSTATE set the state of the apply filter field for the
% selected data objects.
% 
% M Hewitson 09-08-07
% 
% $Id$
% 

% get data objects
didx  = ldv_getselecteddobjs(handles);
dobjs = getappdata(handles.main, 'dobjs');

% loop through selected objects
for idx=didx
  
  switch state
    case 'on'
      dobjs.objs(idx).filters.apply = 1;
    case 'off'
      dobjs.objs(idx).filters.apply = 0;
    otherwise
      error('### unknown filter state');
  end
  
end

% set objects again
setappdata(handles.main, 'dobjs', dobjs);
% update list
ldv_setdobjslist(handles, dobjs, didx(1));
ldv_setnobjsdisplay(handles, dobjs);

% END