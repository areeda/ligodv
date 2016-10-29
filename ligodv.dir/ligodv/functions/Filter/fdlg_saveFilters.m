function fdlg_saveFilters(handles)

% FDLG_SAVEFILTERS saves the list of filters to a .mat file that can be
% reloaded later.
% 
% M Hewitson 16-11-06
% 
% $Id$
% 

% get all the filters in the list
filters = getappdata(handles.main, 'filters');

% get selected objects
fidx = get(handles.fdlg_filterList, 'Value');

% prepare output structure
fobjs        = [];
fobjs.nfilts = 0;

for idx=fidx
 
  % get this object
  fobjs.nfilts = fobjs.nfilts+1;
  fobjs.filt(fobjs.nfilts) = filters.filt(idx);
    
end

% save objects
if fobjs.nfilts > 0
  
  %% Get filename
  [filename, pathname] = uiputfile('*.mat', 'MAT-file output');
  outfilename = [pathname filename];
  if ~isempty(outfilename)
    save(outfilename, 'fobjs');
  end
else
  error('### Select some filter objects first.');  
end


% END