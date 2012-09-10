function lpfilt = ldv_FIRlowpass(R, L, fc, fs, name)
% LDV_FIRlowpass
% 
% Makes an FIR filter using fir1() and
% returns a .filt structure.
% 
% M Hewitson 28-07-06
% 
% 
% $Id$
%


if (fc > 0.5*fs | fc<0)
  error('fc must lie between 0 and Fs/2')
end

N     = 2*R*L-2;
% lpfilt = fir1(N, fc, kaiser(N+1, 16), 'noscale');
nfc   = 2*fc/fs;
a     = fir1(N, nfc);
ntaps = length(a);

% build lpfilt object

lpfilt.name   = name;
lpfilt.fs     = fs;
lpfilt.ntaps  = ntaps;
lpfilt.L      = L;
lpfilt.R      = R;
lpfilt.gd     = R*L-1;
lpfilt.fc     = nfc;
lpfilt.a      = a;
lpfilt.gain   = 1;
lpfilt.histL  = ntaps-1;
lpfilt.hist   = zeros(1, lpfilt.histL);


% END


