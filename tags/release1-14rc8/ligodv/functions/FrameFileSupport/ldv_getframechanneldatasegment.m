function [xo,fso,unitX,unitY]  = ldv_getframechanneldatasegment(startgps, stopgps, channel, handles)
% LDV_GETFRAMECHANNELDATASEGMENT get a segment of data for a particular
% channel.
% 
% M Hewitson 28-09-06
% 
% $Id$
% 

% some setup
nsecs    = stopgps-startgps;
secsleft = double(nsecs);

ts  = double(startgps);
xo  = [];
fso = -1;

while secsleft > 0
  
  disp('  ');
  % get a file for the current time
  ifile = dv_ff_getFileFromTime(handles, ts);
  % frame offset into this file for this time?
  foff = floor((ts - ifile.start)/ifile.frlen);
  
  % how many seconds can we read?
  getsecs = double(ifile.duration) - foff;
  if getsecs > secsleft;
    getsecs = secsleft;
  end
  
  getframes = ceil(getsecs / ifile.frlen);
  frend = ifile.start + ifile.frlen;
  if (getsecs + ts) > frend
    getsecs = frend-ts;
  end
  dv_disp('  + frame offet: %d frames', foff);
  dv_disp('   + reading %d secs (%d frames) from %s [%d]', getsecs, getframes, ifile.path, ts);
  
  % read all data from the frame file
  % !! Except this is stupid for large frame files
  %    need to determine the offset number of frames
  %    - this could be zero if we have only one frame
  %      as in the ligo case.
  % 
  if fso < 0
    [x,tsamp,fvals,gps0,strStart,adcComment,adcUnit, exinfo] = ...
      frextract(ifile.path,channel);
  end
  
  disp(sprintf('calling: [x,tsamp,fvals,gps0,strStart,unitX,unitY]=frgetvect(%s,%s,%d,%d,0)', ifile.path, channel, ts, getsecs))
  
  [x,tsamp,fvals,gps0,strStart,unitX,unitY] = ...
     frgetvect(ifile.path,channel,double(ts),double(getsecs),0); 
   
  dv_disp('    + got %d samples', length(x));
  gps0
%   toff = ts - ifile.start
%   ts
%   min(tsamp+gps0)
%   max(tsamp+gps0)
  ftoff = ifile.frlen*foff;
  
  % something's strange here. For VIRGO gps0 
  % returns the start of the frame file, not 
  % the start of the data I asked for.
  tgot = tsamp+round(gps0);
  idx  = find(tgot >= ts & tgot < ts+getsecs);
  scale = exinfo(5);
  if scale == 0
    scale = 1;
  end
  fso   = exinfo(6);
  xo = [xo;x(idx)*scale];
  
  % move on
  gotsecs = length(xo)/fso;
  secsleft = secsleft - gotsecs;
  ts       = ts + gotsecs;
  
end

% END