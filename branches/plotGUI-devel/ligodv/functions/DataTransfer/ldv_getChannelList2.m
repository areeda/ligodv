%% ldv_getChannelList2 - use java to get a partial list of channels
function ldv_getChannelList2(handles,srchParams)
%LDV_GETCHANNELLIST2  - use java to get a partial list of channels
%   take advantage of the local database in the SWIG bindings for fast
%   searching
    ldv_setStatus('searching for channels');
    % get server
    server = ldv_getserver(handles);
    % get port
    port = ldv_getport(handles);
    % make server:port string
    serverstring = [server ':' num2str(port)];

    % get data type selected
    dtype = ldv_getselectionbox(handles.gd_dataTypeSelect);

    % NDS2 data types are:
    % 'online': online data from shared memory or e.g. dmt h(t) channels
    % 'raw': raw (archived) data frames
    % 'reduced': decimated data from rds frames
    % 'm-trend': minute trend channels.
    % 's-trend': second trend channels 

    % Get channel structure from NDS2
    ldv_disp('*** Getting %s channel info from NDS2 server: %s', dtype, serverstring);
    switch dtype
        case 'raw data'
          nds2dtype='raw';

        case 'reduced data'
            nds2dtype='reduced';

        case 'second trends'
            nds2dtype='s-trend';

        case 'minute trends'
            nds2dtype='m-trend';

    end
    try
        watchon;
        channels = NDS2_JGetChannels(serverstring,nds2dtype,-1,srchParams);
        %set(channels, 'Timeout', 5);
    catch e
        ermsg = e.message;
        ermsg = {ermsg,' ',...
            'If ligoDV has worked before this is may be due to an expired Kerberos ticket',...
            ' ',...
            'But it could also be any number of network, Internet or configuration problems'};

        ldvMsgbox(ermsg,'Problem getting channel list','warn');
        fprintf(['Error searching channels ' e.message '\n']);
        watchoff;
    end
    
    % channels is a struct array with fields:
    % name
    % chan_type
    % rate
    % data_type
    % signal_gain
    % signal_offset
    % signal_slope
    % signal_units


    if (exist('channels','var'))
        if (~isempty(channels))
            
            % save the full channel list as app data
            setappdata(handles.main, 'FullChannelList', channels);

            % export chans variable
            assignin('base', 'channels_raw', channels);

            nchan= length(channels);
            liststr = cell(1,nchan);
            for j = 1:length(channels)
                namestr = char(channels(j).name);
                rate = channels(j).rate;
                liststr{j} = sprintf('%-40.40s (%5d)', namestr, rate);
            end

            try
                % make string list of channels
                channels = char(liststr);
            catch e
                error(['Channel information not available.' e.message]);
            end

            % export chans variable
            assignin('base', 'channels_final', channels);
            ldv_disp('*** Retrieved %d channels', length(channels));

            % Set channel list fields
            set(handles.channelList, 'String', channels);
            set(handles.channelList, 'Value', 1);
        else
            watchoff;
            ldvMsgbox('Search did not return any matches.', ...
                            'No channels');
        end
    end
    watchoff;
    ldv_setStatus('Ready');
end

