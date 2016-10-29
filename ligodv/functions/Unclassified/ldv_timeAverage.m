function [to,xo] = ldv_timeAverage(t, x, fs, avLength)

% LDV_TIMEAVERAGE make a time average of a time-series data vector.
% 
% M Hewitson 30-08-06
% 
% $Id$
% 

% how many samples per average?
slength = round(avLength*fs);

% how many averages?
Nx = length(x);
Nx/slength;
Na = ceil(Nx/slength);

% do we need to zero pad?
Nxo = slength*Na;
if Nxo > Nx
  x = [x.' zeros(1,Nxo-Nx)];
end

% reshape vector and take mean
xo = mean(reshape(x, slength, Na), 2);
to = linspace(0, avLength-1/fs, slength);

% END

