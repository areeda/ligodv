%% NDS_JGetData fetches time series data from an NDS or NDS2 server
function [datalist, wantsToCancel] = NDS2_JGetData(namelist, start, duration, ...
                                server,progBar )
%NDS_GetData  Get time series data from a LIGO NDS server
%
%  This function is designed to have exactly the same name and syntax as
%  the analagous function used to talk to NDS version 1 servers.  However,
%  this function talks to NDS2 servers by default and automatically falls
%  back to NDS1 protocol if the connection with nds2 protocol fails.
% 
%  Usage:
%
%    datalist = NDS_GetData(namelist, start, duration, server, chanlist)
%
%  where:
%  Input:
%    namelist is a list of channel names, e.g. {'H1:LSC-DARM_ERR' 'H2:LSC-DARM_ERR'}
%    start    is the GPS start time of the requested data
%    duration is the number of seconds to fetch.
%    server   is a string with the NDS2 server IP address (or name) and port ('<ip-addr>:<port>')
%    chanlist is a Matlab cell-array containing channel information, in the
%             format returned by NDS_GetChannels. 
%
%  Returns:
%    datalist is a Matlab cell-array containing requested data
%             name           Channel name
%             group_num      Group number (Channel type in NDS2)
%             rate           Sample rate
%             tpnum          Test-point number (nds1 only)
%             bps            Bytes per sample
%             data_type      Data type
%             signal_gain    Online signal gain
%             signal_offset  Online signal offset
%             signal_slope   Online signal slope
%             signal_units   Online Signal unit string
%             start_gps_sec  Data start GPS time
%             duration_sec   Data duration in seconds
%             data           Data array
%             exists         Existence flag (non-existent == 0).
%
% See also NDS_GetChannels, NDS2_GetChannels and NDS2_GetData.
    logTxt = sprintf('Name list: %s, start: %d, duration: %d, server: %s', ...
        char(namelist(1)),start,duration,server);
    disp(logTxt);  
     
    p=strfind(server,':');
    srv=server;
    port=31200;
    if (p > 1)
        srv=server(1:p-1);
        port=str2double(server(p+1:length(server)));
    end
    
    conn=nds2.connection(srv,port);
    conn.iterate(start, start+duration, namelist);
    t=start;
    wantsToCancel = false;
    bufn=1;
    inp=1;
    while t < start+duration && ~wantsToCancel
        buffers=conn.next();
        nbuf = length(buffers);
        for b=(1:nbuf)
            
            buf = buffers(b);
            chan = buf.getChannel;

            if bufn == 1
                % create the structure on the first buffer
                sampleRate=chan.getSampleRate;
                if (sampleRate > 0.0166 && sampleRate < 0.0168)
                    sampleRate=1/60; % minute trends need more accuracy to calculate # pnts
                end
                dataSize=round(sampleRate*duration);
                data = ...
                struct(...
                    'name', chan.getName, ...
                    'group_num', chan.getChannelType, ...
                    'rate', sampleRate, ...
                    'tpnum', 0, ...
                    'bps', DataType.getBytesPerSample(chan.getDataType), ...
                    'data_type', chan.getDataType, ...
                    'signal_gain', 1, ...
                    'signal_offset', 0, ...
                    'signal_slope', 1, ...
                    'signal_units', '', ...
                    'start_gps_sec', buf.getGpsSeconds, ...
                    'duration_sec', duration, ...
                    'data', zeros(1,dataSize), ...
                    'exists', 1 ...
                );
            end
            d=buf.getData;
            nd=length(d);
            dt = nd/sampleRate;
            t=t+dt;
            progBar.bumpCurTally(dt);
            data.data(inp:inp+nd-1)=d;
            inp = inp + nd;
            bufn = bufn+1;
        end       
    end
    if wantsToCancel
        datalist = 'canceled';
        canceled = true;
    else
        datalist=data;
    end
end
