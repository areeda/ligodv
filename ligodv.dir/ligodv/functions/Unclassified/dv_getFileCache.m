function fcache = dv_getFileCache(handles)

% DV_GETFILECACHE returns the current file cache.
% 
% M Hewitson 27-09-06
% 
% $Id$
% 

ldv_settings  = getappdata(handles.main, 'ldv_settings');
fcache    = ldv_settings.ff.fcache;

% END