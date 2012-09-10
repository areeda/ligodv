function dv_ffSetNfiles(handles)

% DV_FFSETNFILES set the Nfiles display by reading the current cache file.
% 
% M Hewitson 27-09-06
% 
% $Id$
% 


settings = getappdata(handles.main, 'settings');
set(handles.ff_Nfiles, 'String', sprintf('%d files', settings.ff.fcache.nfiles));


% END