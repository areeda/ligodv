function ldv_setlatest(handles, latest)

% LDV_SETLATEST set the latest value from a server in the UTC and GPS
% fields.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

utclatest = ldv_gps2utc(latest);

set(handles.utcLatest, 'String', utclatest);
set(handles.gpsLatest, 'String', num2str(latest));


% END

