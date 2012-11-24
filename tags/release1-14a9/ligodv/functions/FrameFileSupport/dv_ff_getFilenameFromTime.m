function filename = dv_ff_getFilenameFromTime(handles, gpstime)

% DV_FF_GETFILENAMEFROMTIME searches the frame file cache to get a filename
% that contains the requested gps time.
% 
% M Hewitson 28-09-06
% 
% $Id$
% 

% get file cache
fcache   = dv_getFileCache(handles);
filename = [];

for f=1:fcache.nfiles
  
  % get this file
  file = fcache.files(f);
  
  fstart = file.start;
  fstop  = fstart + file.duration;
  if gpstime >= fstart && gpstime <= fstop
    
    dv_disp('* file found %s', file.path);
    filename = file.path;
  end
  
end




% END