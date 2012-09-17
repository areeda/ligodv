function dv_fcache2ffl(filename, fcache)

% DV_FCACHE2FFL convert a dataviewer frame cache structure to an ffl array
% for output to text file.
% 
% M Hewitson 05-10-06
% 
% $Id$
% 

fd = fopen(filename, 'w+');

for f=1:fcache.nfiles
  
  file = fcache.files(f);
  fprintf(fd, '%s   %f   %d   %f   %f\n', file.path, file.start, file.duration, 0, 0);
  
end


fclose(fd);



% END