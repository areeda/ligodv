function filt = ldv_bandpass(gain, fs, order, ripple, f)

% LDV_BANDPASS build an IIR bandpass filter object.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

if(f(1) > fs/2)
  msg =   '### f(1) must be < fs/2';
  %mymsg = sprintf(msg);
  %mb = msgbox(mymsg, 'Input Error', 'error');
  %waitfor(mb);
  error(msg);    
end
if(f(2) > fs/2)
  msg =   '### f(2) must be < fs/2';
  %mymsg = sprintf(msg);
  %mb = msgbox(mymsg, 'Input Error', 'error');
  error(msg);
end
if(f(1) > f(2))
  msg =   '### f(1) must be < f(2)';
  %mymsg = sprintf(msg);
  %mb = msgbox(mymsg, 'Input Error', 'error');
  error(msg);    
end

filt.name           = 'bandpass';
filt.fs             = fs;
filt.ntaps          = 2*order+1;
[filt.a, filt.b]    = cheby1(order, ripple, 2.*f./fs);

filt.gain    = gain;
filt.histin  = zeros(1,filt.ntaps-1);       % initialise input history
filt.histout = zeros(1,filt.ntaps-1);       % initialise output history


% END
