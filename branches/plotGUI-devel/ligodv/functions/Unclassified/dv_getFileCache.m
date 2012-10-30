function fcache = dv_getFileCache(handles)

% DV_GETFILECACHE returns the current file cache.
% 
% M Hewitson 27-09-06
% 
% $Id$
% 

settings  = getappdata(handles.main, 'settings');
fcache    = settings.ff.fcache;

% END