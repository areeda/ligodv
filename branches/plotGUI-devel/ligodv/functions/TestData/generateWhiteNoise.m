function x = generateWhiteNoise( param )
%GENERATEWHITENOISE White noise uses Matlab's random number generator
%   Detailed explanation goes here
    
    npts = param.nPts;
    
    x = rand(1,npts);
    
end

