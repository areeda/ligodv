function result = dv_dobjcompare(dobj1, dobj2)

% DV_DOBJCOMPARE compares two data objects. Returns 1 is they are the same,
% 0 otherwise.
% 
% M Hewitson 26-07-06
% 
% $Id$

result = 0;

% Compare
if strcmp(dobj1.channel,dobj2.channel)          && ...          % channel name
   dobj1.id == dobj2.id                         && ...          % id
   dobj1.startgps == dobj2.startgps             && ...          % start time
   dobj1.stopgps  == dobj2.stopgps              && ...          % stop time 
   strcmp(dobj1.source.type, dobj2.source.type) && ...          % source
   dobj1.preproc.resample.R == dobj2.preproc.resample.R && ...  % resample
   dobj1.preproc.whitening  == dobj2.preproc.whitening  && ...  % whitening
   dobj1.preproc.f0  == dobj2.preproc.f0                && ...  % het f0
   strcmp(dobj1.preproc.math.cmd, dobj2.preproc.math.cmd...     % math command
   )
  result = 1;
end


% END