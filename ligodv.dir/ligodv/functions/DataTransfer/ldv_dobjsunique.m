function dobjs = ldv_dobjsunique(dobjs, newdobjs, handles)

% LDV_DOBJSUNIQUE checks a set of dobjs against an existing set and returns
% an array of those that are unique between the two sets.
% 
% M Hewitson 26-07-06
% 
% $Id$

ldv_settings = getappdata(handles.main, 'ldv_settings');

% loop through new data objects
for j=1:newdobjs.nobjs
  
  % check against each of existing data objects
  notfound = 1;
  for k=1:dobjs.nobjs
    
    if ldv_settings.general.debugLevel > 1
      ldv_disp('* comparing: (%s|%d) against (%s|%d)',...
            dobjs.objs(k).channel, dobjs.objs(k).startgps,...
            newdobjs.objs(j).channel, newdobjs.objs(j).startgps);
    end
    
    if dv_dobjcompare(dobjs.objs(k), newdobjs.objs(j))
      ldv_disp('!! data object %02d:%s is already in set', newdobjs.objs(j).id, newdobjs.objs(j).channel);
      notfound = 0;      
    end
  end
  
  if notfound
    dobjs.counter       = dobjs.counter + 1;
    newdobjs.objs(j).id = dobjs.counter;
    dobjs.objs          = [dobjs.objs newdobjs.objs(j)];
    dobjs.nobjs         = dobjs.nobjs + 1;
  end
end



% END

