function dv_launchsptool(handles)

% DV_LAUNCHSPTOOL launch MATLAB's sptool for the selected data objects.
% 
% M Hewitson 30-08-06
% 
% $Id$
% 

% get selected objs
dobjsidx = ldv_getselecteddobjs(handles);
dobjs    = getappdata(handles.main, 'dobjs');
nobjs    = length(dobjsidx);
% objs     = 

% Modify data object names since SPTool vectors cannot have colons or dots
if nobjs>0
    fprintf('\n')
    display('Loading data objects into SPTool')
    display('--------------------------------')
  for j=1:nobjs
    obj = dobjs.objs(dobjsidx(j));
    chname = obj.channel;
    chname = strrep(strrep(chname,'G1:','G1_'),'-','_');
    chname = strrep(strrep(chname,'L1:','L1_'),'-','_');
    chname = strrep(strrep(chname,'H1:','H1_'),'-','_');
    chname = strrep(strrep(chname,'H2:','H2_'),'-','_');
    chname = strrep(strrep(chname,'L0:','L0_'),'-','_');
    chname = strrep(strrep(chname,'H0:','H0_'),'-','_');
    chname = strrep(strrep(chname,'V1:','V1_'),'-','_');
    chname = strrep(chname,'.','_');
    display(['Loaded: ', chname])
    sptool('load', 'Signal', [obj.data.x], obj.data.fs, chname)
  end
  fprintf('\n')
else
  ldv_disp('!! Select a data object first.');  
end



% END