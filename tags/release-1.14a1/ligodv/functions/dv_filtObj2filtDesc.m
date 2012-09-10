function filters = dv_filtObj2filtDesc(fobjs)

% DV_FILTOBJ2FILTDESC convert filter objects to filter descriptions.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% init filter descriptions
filters.filts  = [];
filters.nfilts = 0;

% loop over filter objects
for f = 1:fobjs.nfilts
  
  % this filter object
  filt  = fobjs.filts(f).filt;
  fdesc = fobjs.filts(f).fdesc;
  
  filters.nfilts = filters.nfilts + 1;
  filters.filt(filters.nfilts).type  = fdesc.type;
  filters.filt(filters.nfilts).f     = fdesc.f;
  filters.filt(filters.nfilts).order = fdesc.order;
  filters.filt(filters.nfilts).gain  = fdesc.gain;
  
  
end



% END