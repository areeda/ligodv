function out = structcat(varargin)

% STRUCTCAT concatonate structures to make one large structure.
% 
% function out = structcat(struct1, struct2, ...)
% 
% 'out' will contain all fields of input structures.
% 
% M Hewitson 06-09-06
% 
% $Id$
% 

out = [];

for s=1:nargin
  
  % get first input structure
  st = varargin{s};
  
  % check fields
  fields = fieldnames(st);
  nf     = length(fields);
  
  for f=1:nf
    
    field = char(fields(f));
    % check if this field already exists
    if isfield(out, field)
      warning(sprintf('!!! duplicate field ''%s'' found - skipping.', field));
    else
      % we can add this field
      eval(sprintf('out.%s = st.%s;', field, field));
    end
  end  
end

% END