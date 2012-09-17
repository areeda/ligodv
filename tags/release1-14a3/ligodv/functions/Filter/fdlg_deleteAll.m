function fdlg_deleteAll(handles)

% FDLG_DELETEALL delete all filters.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% prepare a new set of objects
fout.filt   = [];
fout.nfilts = 0;

% set data
setappdata(handles.main, 'filters', fout);
fdlg_setFilterList(handles);




% END