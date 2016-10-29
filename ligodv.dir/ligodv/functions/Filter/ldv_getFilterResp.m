function resp = ldv_getFilterResp(obj, f)

% LDV_GETFILTERRESP get the accumulated response of all filters for a given
% object.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% default response
resp = ones(size(f));

for ft = 1:obj.filters.nfilts
  
  % get this filter
  filt = obj.filters.filts(ft).filt;

  % get response for this filter
  [fd, fresp] = ldv_iirfiltresp(f, filt);  
  resp = resp.*fresp.';
  
end
% END