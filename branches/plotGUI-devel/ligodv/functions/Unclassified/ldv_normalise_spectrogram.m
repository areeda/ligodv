function [nsxx, mu, sig] = ldv_normalise_spectrogram(f, sxx)

% LDV_NORMALISE_SPECTROGRAM normalise a spectrogram matrix by the mean
% spectrum over the full TF map.
% 
% M Hewitson 10-08-06
% 
% $Id$
% 


% compute average spectrum
mu = (mean(sxx, 2));

% % plot averaged spectrum
% figure;
% loglog(mu)

% compute std
sig = std(sxx, 0, 2);

% how many time-slices?
sz    = size(sxx);
ncols = sz(sz~=length(f));

% build normalised matrix
nsxx = zeros(sz);
for j=1:ncols
%   nsxx(:, j) = ((sxx(:,j) - mu)./sig); % DV6 method
  nsxx(:, j) = sxx(:,j)./mu; % Simple normalization by mean spectrum 
end


% END