function newfilters = fdlg_loadFilters(handles)

% FDLG_LOADFILTERS loads filters from a .mat file.
% 
% M Hewitson 16-11-06
% 

% get filename 
[filename, pathname] = uigetfile('*.mat', 'MAT-file input');
infilename = [pathname filename];
if isequal(filename,0)|isequal(pathname,0)
  error('### File not found');
else
  in = load(infilename);
  newfilters = in.fobjs;
end


% END