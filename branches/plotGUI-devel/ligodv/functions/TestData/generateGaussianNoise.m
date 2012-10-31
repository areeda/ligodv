function generateGaussianNoise( handles )
%GENERATEGAUSSIANNOISE Summary of this function goes here
%   This uses the Box-Muller method described here
%   http://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution

    fs = 32768;  % pick a sample frequency
    ncyc = 16;   % pick a number of cycles
    strtTime = 1000000000;  % round gps time =Wed Sep 14 01:46:25 GMT 2011
    
    npts = fs*ncyc; %number of data points
    
    u = rand(npts,1);
    v = rand(npts,1);
    x = sqrt(-2 * log(u)) .* cos(2 * pi * v) * 0.25;
    
    obj = DataObject();
    obj.setChanName('Gaussian_noise_pat');
    obj.setServer('local');
    obj.setFs(fs);
    obj.setStart(strtTime);
    obj.setStop(strtTime+ncyc);
    obj.setX(x);
    
    newobj = obj.getDataPoolObj();
    add1toDataPool(handles,newobj);



end

