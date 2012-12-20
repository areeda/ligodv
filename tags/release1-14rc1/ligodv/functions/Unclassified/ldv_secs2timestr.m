function tstr = ldv_secs2timestr(secs)

% LDV_SECS2TIMESTR convert a number of seconds to HH:MM:SS string.
% 
% M Hewitson 26-07-06
% 
% $Id$

% how many hours?
hours = (secs - mod(secs, 3600))/3600;
secs  = mod(secs, 3600);

% how many minutes?
mins = (secs - mod(secs, 60))/60;
secs = mod(secs, 60);

tstr = sprintf('%02d:%02d:%02d', hours, mins, secs);


% END