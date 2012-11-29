function filt = ldv_bandreject(gain, fs, order, ripple, f)

% LDV_BANDREJECT build an IIR bandreject filter object.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 


if(f(1) > fs/2)
  error('### f(1) must be < fs/2');
end
if(f(2) > fs/2)
  error('### f(2) must be < fs/2');
end
if(f(1) > f(2))
  error('### f(1) must be < f(2)');
end

filt.name           = 'bandreject';
filt.fs             = fs;
filt.ntaps          = 2*order+1;
[filt.a, filt.b]    = cheby1(order, ripple, 2.*f./fs, 'stop');

filt.gain    = gain;
filt.histin  = zeros(1,filt.ntaps-1);       % initialise input history
filt.histout = zeros(1,filt.ntaps-1);       % initialise output history


% END
