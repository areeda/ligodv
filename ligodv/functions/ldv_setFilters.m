function ldv_setFilters(handles, filters)

% LDV_SETFILTERS for each selected data object, build the list of filters
% and attach them to the data object.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get selected data objects
dobjs = getappdata(handles.main, 'dobjs');
didx  = ldv_getselecteddobjs(handles);


% build progress bar
% hw = waitbar(0, 'Building filters...');
% N  = length(didx) * filters.nfilts;
% n  = 1;

% loop through filter list
if dobjs.nobjs > 0
  for idx=didx

    % get data object
    dobj = dobjs.objs(idx);
    fs   = dobj.data.fs;

    % build filter objects
    for ft = 1:filters.nfilts

      % build this filter
      fobj = ldv_buildIIRFilter(filters.filt(ft), fs);

      % add filter object to data object
      nf = dobjs.objs(idx).filters.nfilts + 1;
      dobjs.objs(idx).filters.apply           = 1;
      dobjs.objs(idx).filters.nfilts          = nf;
      dobjs.objs(idx).filters.filts(nf).filt  = fobj;
      dobjs.objs(idx).filters.filts(nf).fdesc = filters.filt(ft);

      % update progress bar
      % n = n + 1;
      % waitbar(n/N, hw);

    end
  end
  % close progress bar
  % close(hw);

  % set data objects again
  setappdata(handles.main, 'dobjs', dobjs);
  % update data object list and info panel
  ldv_setdobjslist(handles, dobjs, didx);
  ldv_setnobjsdisplay(handles, dobjs);
end



% END