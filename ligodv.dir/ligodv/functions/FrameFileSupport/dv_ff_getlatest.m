function [earliest,latest] = dv_ff_getlatest(handles)

% DV_FF_GETLATEST get the latest time from the file cache.
% 
% M Hewitson 28-09-06
% 
% $Id$
% 

% get the file cache
ldv_settings = getappdata(handles.main, 'ldv_settings');
fcache   = ldv_settings.ff.fcache;

latest = 0;
earliest = fcache.files(1).start;
h = waitbar(0, 'Scanning frame cache...');

for f=1:fcache.nfiles
  
  gpsstart = fcache.files(f).start;
  nsecs    = fcache.files(f).duration-1;
  if gpsstart > latest
    latest = gpsstart + nsecs;
  end
  if gpsstart < earliest
      earliest = gpsstart;
  end
  waitbar(f/fcache.nfiles, h);
end

close(h);


% END