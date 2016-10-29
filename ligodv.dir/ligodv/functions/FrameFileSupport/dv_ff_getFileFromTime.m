function ofile = dv_ff_getFileFromTime(handles, gpstime)

% DV_FF_GETFILEFROMTIME get a file structure for the given gpstime.
% 
% M Hewitson 28-09-06
% 
% $Id$
% 

% get file cache
fcache   = dv_getFileCache(handles);
filename = [];

if fcache.nfiles == 0
  error('# build or load a frame cache first');
end

for f=1:fcache.nfiles
  
  % get this file
  file = fcache.files(f);
  
  fstart = file.start;
  fstop  = fstart + file.duration;
  
  if gpstime >= fstart && gpstime < fstop
    
    dv_disp('* file found %s', file.path);
    info = mFrInfo(file.path, 'INFO');
    ofile = file;
    ofile.frlen = info.duration/info.nframes;
    return
  end
  
end

error('# no matching file found');

% END