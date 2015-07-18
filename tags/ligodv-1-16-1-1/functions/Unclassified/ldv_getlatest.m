function latest = ldv_getlatest(handles)

% LDV_GETLATEST gets the current time from system Unix time.
% should be rewritten to get latest time from NDS server if the
% NDS client makes that information available.
%
% J Smith 1/28/08 adapted from M Hewitson 25-07-06
%
% $Id$
%


% latest = ldv_utc2gps(datestr(now, 31));

% get Unix time (ms since Jan 1, 1970, 00:00 UTC)
% from system time
import java.util.*;
d = Date;
unixms = d.getTime(); % Unix time in ms
unixs = floor(unixms/1000); % Current unix second

gpsunixoff = 315964800; % Offset between Unix and GPS time
gpssec_noleap = unixs - gpsunixoff; % GPS time without leap seconds
leapSeconds = ldv_getleapsecond(gpssec_noleap); % Leap seconds since GPS start
latest = gpssec_noleap + leapSeconds;

% END
