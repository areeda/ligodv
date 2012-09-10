function fdlg_exportFilters(handles)

% FDLG_SAVEFILTERS saves the list of filters to a .mat file that can be
% reloaded later.
% 
% M Hewitson 16-11-06
% 
% $Id$
% 

% check current workspace variables
basename = 'ex_filts';
ex = 0;
n  = [];
vars = evalin('base', 'who');
for j=1:length(vars)
  v = char(vars{j});
  if strncmp(basename, v, length(basename)) == 1
    % get the number
    n = [n str2num(v(end-1:end))];
  end
end

% increment 
ex = max([n ex])+1;

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
  varname = sprintf('%s_%02d', basename, ex);
  assignin('base', varname, fobjs);
  ldv_disp('*** %d filters exported as structure %s', length(fobjs), varname);
else
  error('### Select some filter objects first.');  
end


% END