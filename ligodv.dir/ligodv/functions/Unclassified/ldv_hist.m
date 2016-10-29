function [x, n, info] = ldv_hist(y, bins, outlier, detrend)


% LDV_HIST histogram the data in y which is between outlier.lower and
% outlier.upper of the data range. Data is sorted and selected before
% histogramming.
% 
% M Hewitson 30-08-06
% 
% $Id$
% 


% sort data
sy = sort(y);

% select outlier fraction
Ny   = length(y);
lidx = floor(outlier.lower*Ny)+1;
uidx = floor(outlier.upper*Ny);
csy  = sy(lidx:uidx);

% compute stats first
info.mu  = mean(csy);
info.std = std(csy);

if detrend
  % detrend?
  csy = ldv_detrend(csy);  
end

% use zero bins to mean pick a good default value
if (bins==0)
    l = length(csy);
    bins = sqrt(l);
    bins= floor(bins);  % make sure it's an integer
end
% histogram

[n,x] = hist(csy, bins);



% END