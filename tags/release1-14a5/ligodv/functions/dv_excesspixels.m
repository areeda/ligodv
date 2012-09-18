function pix = dv_excesspixels(f, sxx, lth, uth)

% DV_EXCESSPIXELS determine those pixels which cross the two thresholds.
% Returns a new TF map with three color levels.
% 
% M Hewitson 15-08-06
% 
% $Id$
% 

% start with dark pixels
pix = -2*ones(size(sxx));

% crossing threshold 1
idx = find(sxx >= lth);
pix(idx) = 0;
% crossing threshold 2
idx = find(sxx >= uth);
pix(idx) = 2;

% END