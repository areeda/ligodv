function fdlg_deleteSelected(handles)

% FDLG_DELETESELECTED delete the selected filters.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get selected objects
fidx = get(handles.fdlg_filterList, 'Value');

% get the full object structure
filters = getappdata(handles.main, 'filters');

% prepare a new set of objects
fout.filt   = [];
fout.nfilts = 0;

% copy those not selected
for j=1:filters.nfilts
  if j~=fidx
    fout.filt   = [fout.filt filters.filt(j)];
    fout.nfilts = fout.nfilts + 1;
  end
end

% set data
setappdata(handles.main, 'filters', fout);
fdlg_setFilterList(handles);




% END