function x = generateGaussianNoise( param )
%GENERATEGAUSSIANNOISE Summary of this function goes here
%   This uses the Box-Muller method described here
%   http://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution

    npts = param.nPts;
    
    u = rand(1,npts);
    v = rand(1,npts);
    x = sqrt(-2 * log(u)) .* cos(2 * pi * v);
    y = sqrt(-2 * log(u)) .* sin(2 * pi * v);
    x = (x + y) / 8;
    
end

