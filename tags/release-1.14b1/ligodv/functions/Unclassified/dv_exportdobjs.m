function dv_exportdobjs(handles)

% DV_EXPORTDOBJS export selected data objects to workspace.
% 
% M Hewitson 12-08-06
% 
% $Id$
% 

% check current workspace variables
basename = 'ex_objs';
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


% get selected objects
didx  = ldv_getselecteddobjs(handles);
dobjs = getappdata(handles.main, 'dobjs');

if length(didx) > 0
  
  ex_objs.objs  = dobjs.objs(didx);
  ex_objs.nobjs = length(didx);
  
  varname = sprintf('%s_%02d', basename, ex);
  assignin('base', varname, ex_objs);
end

ldv_disp('*** %d objects exported as structure %s', length(didx), varname);

% END