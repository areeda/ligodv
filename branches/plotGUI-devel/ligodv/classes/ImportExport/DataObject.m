classdef DataObject < handle
    %DataObject class represents a single object in the Data Pool
    %   A data object is usually transfered from a server and represents
    %   a time interval of data sampled from an instrument channel.
    %   It may also originate mathematically, from a frame file or yet to
    %   be determined sources.
    %
    %   This class is meant to ease the creation and access of LigoDV data 
    %   objects
    
    properties (SetAccess = private, GetAccess = public)    % public get is for debugging only
        % top level in the object struct
        id=0;
        channelName = 'unknown';
        startgps=0;
        stopgps=0;
        comment='';
        
        % fields packed into source struct
        type='unknown';
        server='unknown';
        port=31200;
        
        % packed into the data struct
        x;              % data vector
        fs=0;           % sample frequency Hz
        unitX='';
        unitY='';
        includingPrime=0;   % seconds of priming data
        
        % record of preprocessing
        heterodyneOn = 0;
        resampleFactor = 1;
        whitening = 0;
        mathString = 'u';
        f0 = 100;
        
        % filters
        nfilts = 0;
        filts = [];
        apply = 0;
    end
    
    methods
        function setId(this,val)
            this.id=val;
        end
        
        function id = getId(this)
            id = this.id;
        end
        
        function setChanName(this,name)
            this.channelName=name;
        end
        
        function chanName = getChanName(this)
            chanName = this.channelName;
        end
        
        function setStart(this, strt)
            this.startgps=strt;
        end
        
        function startGps = getStart(this)
            startGps = this.startgps;
        end
        
        function setStop(this,stp)
            this.stopgps=stp;
        end
        
        function stopGps = getStop(this)
            stopGps = this.stopgps;
        end
        
        function duration = getDuration(this)
            duration = this.stopgps - this.startgps;
        end
        
        function setX(this,xd)
            this.x = xd;
        end
        
        function x=getX(this)
            x=this.x;
        end
        
        % return the data as a 2xn matrix where ts(1,:) is time vector
        % t(2,:) is the channel data
        function ts = getTimeSeries(this)
            d = this.getDuration();
            nsamp = d * this.getFs();
            t = [0:nsamp] / fs + this.getStart();
            ts = [t;this.getX()];
        end
        
        function setFs(this,f)
            this.fs = f;
        end
        
        function fs = getFs(this)
            fs = this.fs;
        end
        
        function setType(this,t)
            this.type=t;
        end
        
        function setServer(this,s)
            this.server=s;
        end
        
        function initFromObj(this,obj)
            this.id = obj.id;
            this.channelName = obj.channel;
            this.startgps = obj.startgps;
            this.stopgps = obj.stopgps;
            this.comment = obj.comment;
            
            this.type = obj.source.type;
            this.server = obj.source.server;
            this.port = obj.source.port;
            
            this.x = obj.data.x;
            this.fs = obj.data.fs;
            this.unitX = obj.data.unitX;
            this.unitY = obj.data.unitY;
            this.includingPrime = obj.data.includingPrime;
            
            this.heterodyneOn = obj.preproc.heterodyneOn;
            this.resample = obj.preproc.resample.R;
            this.whitening = obj.preproc.whitening;
            this.mathString = obj.preproc.math.cmd;
            this.f0 = obj.preproc.f0;
            
            this.nfilts = 0;
            this.filts = [];
            this.apply = 0;
        end;
        
        function obj = getDataPoolObj(this)
            obj.id=this.id;
            obj.channel = this.channelName;
            obj.startgps = this.startgps;
            obj.stopgps = this.stopgps;
            obj.comment = this.comment;
            
            source.type = this.type;
            source.server = this.server;
            source.port = this.port;
            obj.source = source;
            
            data.x = this.x;
            data.fs = this.fs;
            data.unitX = this.unitX;
            data.unitY = this.unitY;
            data.includingPrime = this.includingPrime;
            obj.data = data;
            
            preprocess.heterodyneOn = this.heterodyneOn;
            resample.R = this.resampleFactor;
            preprocess.resample = resample;
            preprocess.whitening = this.whitening;
            math.cmd = this.mathString;
            preprocess.math = math;
            preprocess.f0 = this.f0;
            obj.preproc = preprocess;
            
            filter.nfilts = this.nfilts;
            filter.filts = this.filts;
            filter.apply = this.apply;
            obj.filters = filter;
            
        end
            
    end
    
end

