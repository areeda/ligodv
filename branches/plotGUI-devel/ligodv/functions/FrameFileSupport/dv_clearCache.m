function dv_clearCache(handles)

% DV_CLEARCACHE clear the frame cache.
% 
% M Hewitson 09-10-06
% 

settings = getappdata(handles.main, 'settings');

fcache = settings.ff.fcache
fcache.nfiles = 0;
fcache.files  = [];
dv_setFileCache(handles, fcache);
dv_ff_setframedir(handles, fcache.rootdir);
dv_ffSetNfiles(handles);


% END