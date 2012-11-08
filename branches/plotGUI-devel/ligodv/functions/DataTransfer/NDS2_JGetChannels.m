%%NDS2_JGetChannels  Get a list of channels from a LIGO NDS server
%  This function returns a cell array of structures containing information
%  about the channels of which the NDS2 server is aware.
%
%  Usage:  
%
%    chanlist = NDS2_GetChannels(server[, chan_type[gps,[, selStruct]])
%
%  Where:  
%
%    server   is a string with the NDS2 server ip address and port ('<ip-addr>:<port>')
%    chantype is the channel type string of the requested channels.
%    gps is the start GPS time.  NDS2 server will only return channels with
%       data available at that time.  -1 means ignore.
%    selStruct selection dialog parameter structure
%           cmd     Command used to exit the dialog
%           fs      Sample frequency
%           fscomp  Comparator (< <= = >= >) for sample freq
%           ifo     Inferometer name (H0, L1, HVE-EX...)
%           subsys  Subsystem (PEM, PSL...)
%           filtstr Name filter string
%       
%
% returns:
%    chanlist is a Matlab array of structures containing channel information
%             name           Channel name
%             channel_type   Channel type string, e.g. 'online', 'raw'.
%             rate           Sample rate
%             data_type      Data type, e.g. 'int_2', 'int_4', 'real_4', 'complex_8'
%             signal_gain    Online signal gain
%             signal_offset  Online signal offset
%             signal_slope   Online signal slope
%             signal_units   Online Signal unit string
%
% See also NDS_GetChannels, NDS_GetData, NDS2_GetData.
function chanlist = NDS2_JGetChannels(server, varargin)
    chan_type='';
    data_type = DataType.DATA_TYPE_ALL;
    gps = -1;
    selStruct = struct('cmd','','fs','','fscomp','',...
        'ifo','', 'subsys','','filtstr','');
    if (nargin > 4)
        error('too many arguments in call to NDS2_JGetChannels');
    end
    if (nargin > 3)
        selStruct = varargin{3};
    end
    if (nargin > 2)
            gps = varargin{2};
    end
    if (nargin > 1)
        chan_type = varargin{1};
    end
    
    disp(sprintf('Call to NDS2_JGetChannels: %s, type: %s, gps: %d', server, chan_type, gps));
    disp(selStruct);
    
    p=strfind(server,':');
    srv=server;
    port=31200;
    if (p > 1)
        srv=server(1:p-1);
        port=str2num(server(p+1:length(server)));
    end
    
    % build the name matching string
    srchStr='';
    
    ifo = selStruct.ifo;
    subsys = selStruct.subsys;
    filtstr = selStruct.filtstr;
    
    k = strfind(filtstr,':');
    hasIfo = ~isempty(k);
    hasSubsys = ~isempty(k) && k < length(filtstr);
    
    if(~hasIfo && ~isempty(ifo) && ~strcmpi(ifo,'any'))
        srchStr=[ifo ':'];
        hasIfo=true;
    end
    
    if (~hasSubsys && ~isempty(subsys) && ~strcmpi(subsys,'any'))
        if (~hasIfo)
            srchStr = '*';
        end
        
        srchStr = [srchStr subsys];
        hasSubsys = true;
    end
    
    if (~isempty(srchStr))
        srchStr = [ srchStr '*' filtstr '*'];
    elseif (~isempty(filtstr))
        srchStr = ['*' filtstr '*'];
    else
        srchStr = ['*'];
    end
    srchStr=upper(srchStr);
    
    % see if they specified a sample frequency range
    fsstr = selStruct.fs;
    fscomp = selStruct.fscomp;
    minFs =0;
    maxFs = 131072;
    if (~isempty(fsstr) && ~strcmpi(fsstr,'any'))
        fs=str2double(fsstr);
        switch(fscomp)
            case '<'
                maxFs = fs-1;
            case '<='
                maxFs = fs;
            case '='
                minFs = fs;
                maxFs = fs;
            case '>='
                minFs = fs;
            case '>'
                minFs = fs+1;
        end
    end
        
    
    
    chtype = ChannelType.str2code(chan_type);
    if (chtype == 0)
        chtype = ChannelType.CHANNEL_TYPE_RAW;
    end
    start = now;
    
    % get the channel list specified
    conn=nds.connection(srv,port);

    chls = conn.findChannels(srchStr, chtype, data_type, minFs, maxFs);

    chTime=(now-start)*24*3600;
    disp(sprintf('conn.find took %.2f sec\n',chTime));
    
    nchan = length(chls);
    nochan = nchan;
    if (chtype == ChannelType.CHANNEL_TYPE_MTREND || chtype == ChannelType.CHANNEL_TYPE_STREND)
        nochan = floor((nchan+4)/5);
    end
    chTypeName = ChannelType.code2str(chtype);
    dtypes = DataType();
    k1=1;
    if (nochan == 0)
        chanlist = [];
    end
    
    for k=[1:nchan]
        chan=chls(k);
        name = chan.getName;
        ctype = chan.getChannelType;
        doit = 1;
        if (ctype == ChannelType.CHANNEL_TYPE_MTREND || chtype == ChannelType.CHANNEL_TYPE_STREND)
            % save only one channel for trends
            p=strfind(name,'.');
            doit=0;
            if (~isempty(p) && length(p) == 1)
                ttype = name(p+1:length(name));
                name = name(1:p-1);
                q = strfind(ttype,'mean');
                doit = ~isempty(q) && length(q) == 1;
            end
        end
        if (doit)
            chanlist(k1) = struct ( ...
            'name',name, ...
            'channel_type', chTypeName, ...
            'rate', chan.getSampleRate, ...
            'data_type', dtypes.getName(chan.getDataType), ...
            'signal_gain', 1, ...
            'signal_offset', 0, ...
            'signal_slope', 1, ...
            'signal_units', '');
       
            if (k1 == 1)
                chanlist(nochan) = chanlist(1);
            end
            k1 = k1 + 1;
        end
        
        if (rem(k,10000) == 0)
            eTime = (now-start)*24*3600;
            disp(sprintf('%d channels processed %.2f sec',k,eTime));
        end
    end
    
end