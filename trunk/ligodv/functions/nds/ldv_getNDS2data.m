function [x,fs]  = ldv_getNDS2data(dtype, server, port,...
    startgps, stopgps,...
    channel, handles,...
    serverchannels)

% LDV_GETNDS2DATA get a segment of data from and NDS2 server. 
%
% J Smith 2009-10-08
%
% $Id$
%

    duration = stopgps - startgps;
    serverstring = [server ':' num2str(port)];

    % get the data segment
    switch dtype

        case 'raw data'
            channel = [channel ',raw'];
            channeldata = NDS_JGetData({channel},...
                startgps,...
                duration,...
                serverstring);

        case 'minute trends'
            channeldata = NDS_JGetData({[channel,',m-trend']},...
                startgps,...
                duration,...
                serverstring);
        case 'second trends'
            channeldata = NDS_JGetData({[channel,',s-trend']},...
                startgps,...
                duration,...
                serverstring);

    %     assignin('base', 'dataout', datalist);

        otherwise

            error('### unknown data type');
    end


    % get units
    units = ldv_setunit(handles);

    if strcmp(units,'Counts')
        % keep data in Counts
        x  = double(channeldata.data);
    else
        % Convert data to Volts by multiplying signal slope
        x  = double(channeldata.data) .* double(channeldata.signal_slope);
    end

    fs = double(channeldata.rate);

    % do any preprocessing requested.
    drawnow;
    
end



% END
