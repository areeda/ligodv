function generateSquareWave( handles )
%GENERATESQUAREWAVE Summary of this function goes here
%   Detailed explanation goes here

    fs = 1024;  % pick a sample frequency
    ncyc = 6;   % pick a number of cycles
    strtTime = 1000000000;  % round gps time =Wed Sep 14 01:46:25 GMT 2011
    
    npts = fs*ncyc; %number of data points
    t = [1:npts]/npts*ncyc*2*pi * 4;
    x = sin(t);
    for i=1:npts
        if (x(i) > 0)
            x(i) = 1;
        else
            x(i) = -1;
        end
    end
    
    obj = DataObject();
    obj.setChanName('4-Hz_square_wave_pat');
    obj.setServer('local');
    obj.setFs(fs);
    obj.setStart(strtTime);
    obj.setStop(strtTime+ncyc);
    obj.setX(x);
    
    newobj = obj.getDataPoolObj();
    add1toDataPool(handles,newobj);


end

