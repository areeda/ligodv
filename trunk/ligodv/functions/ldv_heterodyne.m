function xo = ldv_heterodyne(xi, fs, hetf)

% LDV_HETERODYNE heterodyne a vector xi and return the magnitude of the
% heterodyned vector.
% 
% M Hewitson 30-08-06
% 
% $Id$
% 

ndata = length(xi);
nsecs = ndata/fs;
ti    = [linspace(0, nsecs-1/fs, ndata)].';
y     = xi .* sin(2*pi*hetf.*ti);

% low pass
% fc = 2*0.85*(hetf)
% rfilt = dv_FIRlowpass(12, 24, fc, fs, 'lowpass');
% [rfilt, yo] = mFIRfilter(rfilt, y);
% ifilt = rfilt;
% [ifilt, yi] = mFIRfilter(ifilt, imag(y));
% fvtool(rfilt.a); 

ldv_disp('resample at %f', 1.8*hetf/fs);

xo = y; 
% xo = [yo(1+rfilt.gd: end).' zeros(1,rfilt.gd)].';


% END