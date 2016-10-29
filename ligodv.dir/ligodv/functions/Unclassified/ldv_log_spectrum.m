function [lf, lxx] = ldv_log_spectrum(f, xx, fs, lf)

% LDV_LOG_SPECTRUM converts a spectral series into a log-spaced spectral
% series by doing simple averaging over the required bands.
% 
% M Hewitson 14-09-06
% 
% $Id$
% 

% go through new frequency vector and build a new psd
nf       = length(lf);
Nf       = length(f);
lxx      = zeros(size(lf));

mexremap = 0;

if mexremap

  lxx = mfremap(f, xx, lf);

  lxx = lxx(:);
%   lf  = lf(:);
  
else
  
  % do first sample
  fl     = 0;
  fu     = (lf(1) + lf(2)) / 2;
  tidx   = find(f>=fl & f<=fu);
  tidx   = tidx(tidx>0 & tidx<=nf);
  lxx(1) = sqrt(mean(xx(tidx).^2));

  for j=2:nf-1

    % find indices
    fl = (lf(j) + lf(j-1)) / 2;
    fu = (lf(j) + lf(j+1)) / 2;

    tidx    = find(f>=fl & f<=fu);
    tidx    = tidx(tidx>0 & tidx<=Nf);
    if isempty(tidx)
      lxx(j) = 0;
    else
      lxx(j)  = sqrt(mean(xx(tidx).^2));
    end

  end 
  
  % do last sample
  fl       = (lf(j) + lf(j-1)) / 2;
  fu       = f(end);
  tidx     = find(f>=fl & f<=fu);
  tidx     = tidx(tidx>0 & tidx<=nf);
  lxx(end) = mean(xx(tidx));
end

lf = lf.';

% END