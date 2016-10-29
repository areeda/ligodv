function x = generateSine( param )
%GENERATESINGLESINE Generate test data with sine gaussian waveform
%   see http://www.ligo.caltech.edu/docs/T/T040055-00.pdf
%   and http://www.ligo.caltech.edu/~ajw/bursts/burstsim.html

    duration = param.duration;  % number of seconds in data
    f0 = param.freq;            % fundamental frequency
    fs = param.fs;              %sample frequency
    Q = param.q;
    
    % calculations
    t = 0:1/fs:duration-1/fs;   % time vector
    tau = Q/(2*pi*f0);          % decay time
    x = exp(-(t-(duration/2)).^2/tau^2).*sin(2*pi*f0.*t);   % calculate Sine-Gaussian time series

end