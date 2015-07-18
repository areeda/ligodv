function x = generateChirp( param )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    ncyc = param.duration;      % number of cycles in data
    freq = param.freq;          % fundamental frequency
    kmax = param.fs/freq/4.5;
    npts = param.nPts; %number of data points

    k =[ 1:npts];
    k = k / npts * kmax;
    t = [1:npts];
    t = t/npts * freq * ncyc * 2*pi;
    t = t .* k;
    x = sin(t);
    %x=t;
    
    if (param.decay)
        % multiply by exponential dampning fn
        cntr=npts/2;
        d = [ cntr - [0 : cntr-1], [0:cntr-1]];
        e = log(.01) *2 /cntr;
        f = exp(e * (cntr-d));
        x = x ./ f;
    end
    
    % scale to go from -1 to 1
    mx = max(x);
    mn = min(x);
    sp = (mx-mn);
   % x = (x-mean(x)) /sp * 2;
    
end

