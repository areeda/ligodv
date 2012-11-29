function cell = dv_strs2cells(varargin)

% DV_STRS2CELLS convert a set of input strings to a cell array.
% 
% M Hewitson 13-08-06
% 
% $Id$
% 


cell = [];
for j=1:nargin
  
  cell = [cell cellstr(varargin{j})];
  
end


% END