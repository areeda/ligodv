function xo = ldv_detrend(x)

% LDV_DETREND remove linear trend from a data vector.
% 
% M Hewitson 30-08-06
% 
% $Id$
% 


xo = detrend(x, 'constant');

% END