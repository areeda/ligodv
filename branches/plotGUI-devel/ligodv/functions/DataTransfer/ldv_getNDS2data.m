function [x,fs]  = ldv_getNDS2data(dtype, server, port,...
    startgps, stopgps, inchannel, handles,progBar)

% LDV_GETNDS2DATA get a segment of data from and NDS2 server. 
%
% J Smith 2009-10-08
%
% $Id$
%

    duration = stopgps - startgps;
    serverstring = [server ':' num2str(port)];

    % isolate just the channel name
    p = strfind(inchannel,' ');
    if (~isempty(p))
        channel = inchannel(1:p(1)-1);
    else
        channel=inchannel;
    end
    
    % get the data segment
    switch dtype

        case 'raw data'
            % looks like we're not supposed to set raw as a channel type
            %channel = [channel ',raw'];
            
        case 'minute trends'
            channel = [channel,',m-trend'];
            
        case 'second trends'
            channel = [channel,',s-trend'];

        case 'reduced data'
            channel = [channel,',reduced'];

        otherwise

            error('### unknown data type');
    end
    channeldata = NDS2_JGetData({channel}, startgps, duration,...
                serverstring,progBar);

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
