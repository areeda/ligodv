%% LDV_GETCHANNELLIST get a list of channels for the specified time from the
% specified source (server, frames, etc).
%
% M Hewitson 26-07-06
%
% $Id$
function ldv_getChannelList(handles)
% get the data retrieval mode

dvmode = ldv_getselectionbox(handles.dvmode);

% based on data retrieval mode get channel list
switch dvmode
    %%%%%%%%%%%%%%%%%%%%%
    %  NDS Server Mode  %
    %%%%%%%%%%%%%%%%%%%%%
    case 'NDS Server'
        % get server
        server = ldv_getserver(handles);
        % get port
        port = ldv_getport(handles);
        % make server:port string
        serverstring = [server ':' num2str(port)];

        % Get channel list from NDS
        ldv_disp('*** Getting channel information from NDS server: %s', serverstring);
        channels = NDS_GetChannels(serverstring);

        % save the full channel list as app data
        setappdata(handles.main, 'FullChannelList', channels);
        % Check whether low sample rate channels should be included
        include_low_sr = false;
        % get rid of test point channels (only useful for real time display)
        idx = find([channels(:).tpnum] == 0); % tpnum>1 for test point chans
        channels = channels(idx);

        if ~include_low_sr
            % get rid of low sample rate channels
            idx = find([channels(:).rate] >= 256);
            channels = channels(idx);
        end

        % export chans variable
        assignin('base', 'channels_raw', channels);

        for j = 1:length(channels)
            namestr = char(channels(j).name);
            ratestr = num2str(channels(j).rate);
            liststr{j} = [namestr, '   (', ratestr, ')'];
        end

        try
            % make string list of channels
            channels = char(liststr);
        catch
            error('Channels information not available. Try another server or with fs<256.')
        end

        % export chans variable
        assignin('base', 'channels_final', channels);
%%
        %%%%%%%%%%%%%%%%%%%%%%
        %  NDS2 Server Mode  %
        %%%%%%%%%%%%%%%%%%%%%%
    case 'NDS2 Server'
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
            channels = NDS2_JGetChannels(serverstring,nds2dtype);
            %set(channels, 'Timeout', 5);
        catch e
            ermsg = e.message;
            ermsg = sprintf('%s\n\n%s\n%s\n',ermsg,...
                'If ligoDV has worked before this is probably due to an expired Kerberos ticket\n',...
                'But may be any number of network, Internet or configuration problems');
            
            ldvMsgbox(ermsg,'Problem getting channel list','warn');
            error(ermsg);
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

        
        if (length(channels) > 0)
            % cut the trend channels out of the list of raw channels
            if (strcmpi('raw',nds2dtype))
                idx = find([channels(:).rate] > 1);
                channels = channels(idx);
            end
            

            % save the full channel list as app data
            setappdata(handles.main, 'FullChannelList', channels);
            % Check whether low sample rate channels should be included
            include_low_sr = false;
            % get rid of test point channels (only useful for real time display)
            %idx = find([channels(:).tpnum] == 0); % tpnum>1 for test point chans
            %channels = channels(idx);

            if (~include_low_sr && strcmpi('raw',nds2dtype))
                % get rid of low sample rate channels
                idx = find([channels(:).rate] >= 256);
                channels = channels(idx);
            end

            % export chans variable
            assignin('base', 'channels_raw', channels);

            nchan= length(channels);
            liststr = cell(1,nchan);
            for j = 1:length(channels)
                namestr = char(channels(j).name);
                rate = channels(j).rate;
                liststr{j} = sprintf('%-33s (%d)', namestr, rate);
            end

            try
                % make string list of channels
                channels = char(liststr);
            catch
                error('Channel information not available. Try another server or with fs<256.')
            end

            % export chans variable
            assignin('base', 'channels_final', channels);
        end
%%
        %         %--- Frame File Mode
        %     case 'Frame File'
        %
        %         % get the start time
        %         startgps = str2num(get(handles.gpsStartInput, 'String'));
        %
        %         % get the corresponding filename
        %         filename = dv_ff_getFilenameFromTime(handles, startgps);
        %
        %         % get channel list
        %         channels = mFrInfo(filename, 'CHANNELS');
        %
        %         % filter out the control channels first
        %         include_low_sr = get(handles.includeControlChansChk, 'Value');
        %         if include_low_sr
        %             control_chans = dv_parsecontrolchans(channels);
        %             channels = strvcat(control_chans, dv_filtercontrolchans(channels));
        %         else
        %             channels = dv_filtercontrolchans(channels);
        %         end
%%
    otherwise
        error('### unknown dataviewer mode');
end

ldv_disp('*** Retrieved %d channels', length(channels));

% Set channel list fields
set(handles.channelList, 'String', channels);
set(handles.channelList, 'Value', 1);

end

% END
