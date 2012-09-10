%%NDS2_JGetChannels  Get a list of channels from a LIGO NDS server
%  This function returns a cell array of structures containing information
%  about the channels of which the NDS2 server is aware.
%
%  Usage:  
%
%    chanlist = NDS2_GetChannels(server[, chan_type[, gps [,minFs]])
%
%  Where:  
%
%    server   is a string with the NDS2 server ip address and port ('<ip-addr>:<port>')
%    chantype is the channel type string of the requested channels.
%    gps      request channels available at te specified GPS time
%    minFs    minimum sample rate frequency to return
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
    gps = -1;
    if (nargin > 3)
        error('too many arguments in call to NDS2_JGetChannels');
    elseif (nargin > 2)
            gps = varargin{2};
    elseif (nargin > 1)
        chan_type = varargin{1};
    end
    
    disp(sprintf('Call to NDS2_JGetChannels: %s, type: %s, gps: %d', server, chan_type, gps));
    
    p=strfind(server,':');
    srv=server;
    port=31200;
    if (p > 1)
        srv=server(1:p-1);
        port=str2num(server(p+1:length(server)));
    end
    
    conn=nds.connection(srv,port);
    chtype = ChannelType.str2code(chan_type);
    if (chtype == 0)
        chtype = ChannelType.CHANNEL_TYPE_RAW;
    end
    start = now;
    
    chls = conn.findChannels('*',chtype);
    chTime=(now-start)*24*3600;
    disp(sprintf('conn.find took %.2f sec\n',chTime));
    
    nchan = length(chls);
    nochan = nchan;
    if (chtype == ChannelType.CHANNEL_TYPE_MTREND || chtype == ChannelType.CHANNEL_TYPE_STREND)
        nochan = floor((nchan+4)/5)
    end
    chTypeName = ChannelType.code2str(chtype);
    dtypes = DataType();
    k1=1;
    
    for k=[1:nchan]
        chan=chls(k);
        name = chan.getName;
        ctype = chan.getChannelType;
        doit = 1;
        if (ctype == ChannelType.CHANNEL_TYPE_MTREND || chtype == ChannelType.CHANNEL_TYPE_STREND)
            % save only one channel for trends
            p=strfind(name,'.');
            
            ttype = name(p+1:length(name));
            name = name(1:p-1);
            doit = strcmpi(ttype,'mean');
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