function dv_setFileCache(handles, fcache)

% DV_SETFILECACHE set the file cache to be the input file cache.
% 
% M Hewitson 27-09-06
% 
% $Id$
% 

ldv_settings = getappdata(handles.main, 'ldv_settings');
ldv_settings.ff.fcache = fcache;
setappdata(handles.main, 'ldv_settings', ldv_settings);


% END