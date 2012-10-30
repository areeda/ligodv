function filt = ldv_pzmodel(pzm, fs)

% LDV_PZMODEL build an IIR pole-zero model filter object.
% 
% J Smith 5/13/08
% 
% $Id$
% 

filt.name        = 'pzmodel';
filt.fs          = fs;
filt.gain    = pzm.gain;
% Get IIR recursion coefficients
[filt.a, filt.b] = ldv_pzm2ab(pzm, fs);

end

% END