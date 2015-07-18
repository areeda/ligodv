function ldv_dobjsSearch(handles)

% LDV_DOBJSSEARCH search the list of data objects for the input text and
% fill the list with the matches. If input is empty, fill list with all
% data objects.
% 
% M Hewitson 05-08-06
% 
% $Id$
% 

% get search text and capitalize it
searchtxt = upper(get(handles.dobjsSearchTxt, 'String'));

% get data objects
dobjs = getappdata(handles.main, 'dobjs');

if isempty(searchtxt)
  % dv_disp('+ setting full list');
  % set full list
  ldv_setnobjsdisplay(handles, dobjs);
  ldv_setdobjslist(handles, dobjs);
else
  
  didx = [];
  
  % tokenise the search string
  [t, r] = strtok(searchtxt);
  cstr = [];
  cstr = [cstr; cellstr(t)];
  while ~isempty(r)
    [t, r] = strtok(r);
    cstr = [cstr; cellstr(t)];
  end
  % search for matching indices
  for j=1:dobjs.nobjs
    
    % is this a match? - check each search string token
    match = 1;
    for k=1:length(cstr)
      idx = strfind(upper(dobjs.objs(j).channel), char(cstr(k)));
      if isempty(idx)
        match = 0;
      end
    end    

    if match
      didx = [didx j];
    end
  end
  % set object list
  dobjset.objs  = dobjs.objs(didx);
  dobjset.nobjs = length(didx);
  ldv_setdobjslist(handles, dobjset);
  ldv_setnobjsdisplay(handles, dobjset);
end

% END