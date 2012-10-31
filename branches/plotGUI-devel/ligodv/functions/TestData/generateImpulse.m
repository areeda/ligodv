function generateImpulse( handles )
%GENERATEIMPULSE Summary of this function goes here
%   Detailed explanation goes here

    fs = 1024;  % pick a sample frequency
    ncyc = 1;   % pick a number of cycles
    strtTime = 1000000000;  % round gps time =Wed Sep 14 01:46:25 GMT 2011
    
    npts = fs*ncyc; %number of data points
    
    x = zeros(npts,1);
    x(fs/2) = 1024;
    
    obj = DataObject();
    obj.setChanName('Impulse_test_pat');
    obj.setServer('local');
    obj.setFs(fs);
    obj.setStart(strtTime);
    obj.setStop(strtTime+ncyc);
    obj.setX(x);
    
    newobj = obj.getDataPoolObj();
    add1toDataPool(handles,newobj);



end

