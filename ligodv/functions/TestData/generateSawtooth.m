function x = generateSawtooth( param )
%GENERATESAWTOOTH Create a test data set containing a sawtooth waveform and
%add to dta pool
%
%   Create a data object, fill it with a sawtooth wave form and add it to
%   the data pool.  It is used to test our analysis functions and for
%   students to get practice with FFTs

    ncyc = param.duration;      % number of cycles in data
    freq = param.freq;          % fundamental frequency
    nharm = param.nHarmonics;   % how many harmonics of fundamental freq
    
    npts = param.nPts; %number of data points
    x = zeros(1,npts);
    for h=1:nharm
        t = [1:npts]/npts * ncyc * freq * h * 2*pi;
        if (param.decay)
            x = x + sawtooth(t)/(2^(h-1));
        else
            x = x + sawtooth(t);
        end
    end

end

