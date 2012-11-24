function filt = ldv_highpass(gain, fs, order, fc)

% LDV_HIGHPASS build an IIR highpass filter object.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

if(fc > fs/2)
  msg =   '### fc must be < fs/2';
  %mymsg = sprintf(msg);
  %mb = msgbox(mymsg, 'Input Error', 'error');
  %waitfor(mb);
  error(msg);
end

filt.name        = 'highpass';
filt.fs          = fs;
filt.ntaps       = order+1;
[filt.a, filt.b] = butter(order, 2*fc/fs, 'high');

filt.gain    = gain;
filt.histin  = zeros(1,filt.ntaps-1);       % initialise input history
filt.histout = zeros(1,filt.ntaps-1);       % initialise output history

% END

