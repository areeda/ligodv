function unit = ldv_getYunits(handles)

% LDV_GETYUNITS gets the Y units from the selected data objects. If the
% objects have different Y units, it returns 'arb'.
% 
% M Hewitson 16-11-06
% 
% $Id$
% 

% get the selected data objects
dobjsidx = ldv_getselecteddobjs(handles);
dobjs    = getappdata(handles.main, 'dobjs');
nobjs    = length(dobjsidx);

unit = dobjs.objs(dobjsidx(1)).data.unitY;
for ob=2:nobjs
  if strcmp(unit, dobjs.objs(dobjsidx(ob)).data.unitY)~=1
    unit = 'various';
  end
end


% END