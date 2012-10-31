function generateSawtooth( handles )
%GENERATESAWTOOTH Create a test data set containing a sawtooth waveform and
%add to dta pool
%
%   Create a data object, fill it with a sawtooth wave form and add it to
%   the data pool.  It is used to test our analysis functions and for
%   students to get practice with FFTs

    fs = 1024;  % pick a sample frequency
    ncyc = 6;   % pick a number of cycles
    strtTime = 1000000000;  % round gps time =Wed Sep 14 01:46:25 GMT 2011
    
    npts = fs*ncyc; %number of data points
    t = [1:npts]/npts*ncyc*2*pi;
    x = sawtooth(t);
    
    obj = DataObject();
    obj.setChanName('Sawtooth_test_pattern');
    obj.setServer('local');
    obj.setType('generated');
    obj.setFs(fs);
    obj.setStart(strtTime);
    obj.setStop(strtTime+ncyc);
    obj.setX(x);
    
    newobj = obj.getDataPoolObj();
    add1toDataPool(handles,newobj);
    

end

