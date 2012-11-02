function x = generateImpulse( param )
%GENERATEIMPULSE Summary of this function goes here
%   Detailed explanation goes here

    npts = param.nPts; %number of data points
    
    x = zeros(npts,1);
    x(npts/2) = 1024;
    
end

