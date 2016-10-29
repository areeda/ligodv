function x = generateSine( param )
%GENERATESINGLESINE Generate test data with one frequency sine wave
%   Detailed explanation goes here

    ncyc = param.duration;      % number of cycles in data
    freq = param.freq;          % fundamental frequency
    nharm = param.nHarmonics;   % how many harmonics of fundamental freq
    
    npts = param.nPts; %number of data points
    x = zeros(1,npts);
    for h=1:nharm
        t = [1:npts]/npts * ncyc * freq * h * 2*pi;
        if (param.decay)
            x = x + sin(t)/(2^(h-1));
        else
            x = x + sin(t);
        end
    end


end

