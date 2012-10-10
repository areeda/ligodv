function newdobjs = ldv_loaddobjs(handles)

% LDV_LOADDOBJS load data objects from a .mat file.
% 
% M Hewitson 12-08-06
% 
% $Id$
% 

% current objs
% dobjs = getappdata(handles.main, 'dobjs');

% get filename 
[filename, pathname] = uigetfile('*.mat', 'MAT-file input');
infilename = [pathname filename];
if isequal(filename,0)|isequal(pathname,0)
%   error('### File not found');
  newdobjs.objs  = [];
  newdobjs.nobjs = 0;
else
  in = load(infilename);
  newdobjs = in.sdobjs;
  
  % unset ids
  for j=1:newdobjs.nobjs
    newdobjs.objs(j).id = -j;
  end
  
end
  


% END