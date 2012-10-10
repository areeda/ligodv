function   sos2plot( soscoef )
%SOS2PLOT Summary of this function goes here
%   Detailed explanation goes here
ADC_noise = 6e-3;
[[z],[p],k] = sos2zp(soscoef);

zero = [z].*2*pi;
pole = [p].*2*pi;
gain = k*(prod(zero)/prod(pole));

f = .1:.1:1e5;
filt = zpk([zero],[pole],gain);
resp = freqresp(filt,2*pi*f);
resp = squeeze(resp);
mag = abs(resp);

dn_line = ones(1e6,1).*ADC_noise;
dn_line = dn_line.*mag;
plot(f,mag);



end

