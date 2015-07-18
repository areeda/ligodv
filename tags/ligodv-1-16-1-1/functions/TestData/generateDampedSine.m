function x = generateDampedSine( param )
%GENERATESINGLESINE Generate test data with one frequency sine wave
%   Detailed explanation goes here

    ncyc = param.duration;      % number of cycles in data
    freq = param.freq;          % fundamental frequency
    nharm = param.nHarmonics;   % how many harmonics of fundamental freq
    
    npts = param.nPts; %number of data points
    x = zeros(1,npts);
    for h=1:nharm
        t = [1:npts]/npts * ncyc * freq * h * 2*pi;
        
        x = x + sin(t);
    end
    % multiply by exponential dampning fn
    cntr=npts/2;
    d = [ cntr - [0 : cntr-1], [0:cntr-1]];
    e = log(.01) *2 /cntr;
    f = exp(e * (cntr-d));
    x = x ./ f;
    
    % scale to go from -1 to 1
    mx = max(x);
    mn = min(x);
    sp = (mx-mn);
    x = (x-mean(x)) /sp * 2;
    
end

