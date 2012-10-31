function generateSinglesine( handles )
%GENERATESINGLESINE Generate test data with one frequency sine wave
%   Detailed explanation goes here

    fs = 1024;  % pick a sample frequency
    ncyc = 6;   % pick a number of cycles
    strtTime = 1000000000;  % round gps time =Wed Sep 14 01:46:25 GMT 2011
    
    npts = fs*ncyc; %number of data points
    t = [1:npts]/npts*ncyc*2*pi * 4;
    x = sin(t);
    
    obj = DataObject();
    obj.setChanName('4-Hz_test_pat');
    obj.setServer('local');
    obj.setFs(fs);
    obj.setStart(strtTime);
    obj.setStop(strtTime+ncyc);
    obj.setX(x);
    
    newobj = obj.getDataPoolObj();
    add1toDataPool(handles,newobj);

end

