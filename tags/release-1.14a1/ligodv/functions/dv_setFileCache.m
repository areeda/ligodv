function dv_setFileCache(handles, fcache)

% DV_SETFILECACHE set the file cache to be the input file cache.
% 
% M Hewitson 27-09-06
% 
% $Id$
% 

settings = getappdata(handles.main, 'settings');
settings.ff.fcache = fcache;
setappdata(handles.main, 'settings', settings);


% END