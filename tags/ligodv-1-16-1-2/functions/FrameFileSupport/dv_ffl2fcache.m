function fcache = dv_ffl2fcache(fflfile, lastLines)

% DV_FFL2FCACHE read an ffl file and return a frame cache file.
% 
% M Hewitson 05-10-06
% 
% $Id$
% 

delims         = ' ';
fcache.files   = [];
fcache.rootdir = '/';
fcache.nfiles  = 0;

% open file
fd = fopen(fflfile);
% read lines
fields = textscan(fd, '%s%f%d%*[^\n]');
% close file
fclose(fd);

% count lines
nl = length(fields{1});
dv_disp('* ffl file has %d entries', nl);

% initialise fcache array
if lastLines < 0
  lastLines = nl;
end
% paths = fields{1}{nl-lastLines+1:nl}
files = struct('path', cell(lastLines,1), 'start',...
                        cell(lastLines,1), 'duration', cell(lastLines,1));
fcache.files  = files;
fcache.nfiles = lastLines;
clear files;
clear paths;

h = waitbar(0, 'Loading ffl file...');

dv_disp('* reading last %d lines', lastLines);
step = ceil(lastLines/50);
n = nl-lastLines-2;
tic
for j=1:lastLines
  n = n + 1;
  % set path
  fcache.files(j).path = char(fields{1}{n});
  % set start time
  fcache.files(j).start = double(fields{2}(n));
  % set duration
  fcache.files(j).duration = double(fields{3}(n));
  % update waitbar
  if mod(j,step)==1
    waitbar(j/lastLines, h);
  end
end
toc
close(h);

% END