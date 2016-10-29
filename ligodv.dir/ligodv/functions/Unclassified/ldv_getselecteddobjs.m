function dobjsidx = ldv_getselecteddobjs(handles)

% LDV_GETSELECTEDDOBJS returns an list of indices into the dobjs structure
% for those that are currently selected in the list.
% 
% M Hewitson 27-07-06
% 
% $Id$
% 

% read selected lines
dobjsidx     = get(handles.dataObjects, 'Value');
dobjsStr     = get(handles.dataObjects, 'String');
if isempty(dobjsStr)
  dobjsidx = [];
  return;
end
dobsSelected = deblank(dobjsStr(dobjsidx,:));

% parse out object ids
nobs = size(dobsSelected,1);
  if nobs == 0
      error('### No data objects selected. Select one or more from Data Pool.');
  end
dids=[];
for d=1:nobs
  ds = strtok(dobsSelected(d,:), ':');
  if ~isempty(str2num(ds))
    dids(d) = str2num(ds);
  end
end

% now find the indices matching these object ids
dobjs    = getappdata(handles.main, 'dobjs');
k = 1;
for d=1:dobjs.nobjs
  oi = dobjs.objs(d).id;
  idx = find(dids == oi);
  if ~isempty(idx)
    dobjsidx(k) = d;
    k = k+1;
  end  
end



% END