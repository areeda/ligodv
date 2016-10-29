function ldv_savedobjs(handles)

% LDV_SAVEDOBJS save selected data objects to a .mat file.
% 
% M Hewitson 12-08-06
% 
% $Id$
% 

% get selected objects
didx  = ldv_getselecteddobjs(handles);
dobjs = getappdata(handles.main, 'dobjs');


% prepare output structure
sdobjs       = [];
sdobjs.nobjs = 0;

for idx=didx
 
  % get this object
  sdobjs.nobjs = sdobjs.nobjs+1;
  sdobjs.objs(sdobjs.nobjs) = dobjs.objs(idx);
    
end

% save objects
if sdobjs.nobjs > 0
  
  %% Get filename
  [filename, pathname] = uiputfile('*.mat', 'MAT-file output');
  outfilename = [pathname filename];
  if ~isempty(outfilename)
    save(outfilename, 'sdobjs')
  end
else
  error('### Select some data objects first.');  
end






% END