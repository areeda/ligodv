function varargout = ldv_disp(varargin)

% LDV_DISP enhanced version of disp.
% 
% M Hewitson 10-08-06
% 
% $Id$
% 


s = sprintf(varargin{1}, varargin{2:end});
disp(s);

if nargout == 1
  varargout{1} = s;
end

% END
