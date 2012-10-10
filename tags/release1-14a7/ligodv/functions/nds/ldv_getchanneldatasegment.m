function [x,fs]  = ldv_getchanneldatasegment(dtype, server, port,...
    startgps, stopgps,...
    channel, handles,...
    serverchannels)

% LDV_GETCHANNELDATASEGMENT get a piece of data from a server.
%
% M Hewitson 28-09-06
%
% $Id$
%

duration = stopgps - startgps;
serverstring = [server ':' num2str(port)];

% get the data segment
switch dtype

    case 'raw data'

        aa = NDS_JGetData({channel},...
            startgps,...
            duration,...
            serverstring,...
            serverchannels);
        
%     assignin('base', 'aaout', aa);

    case 'second trends'

        aa = NDS_GetSecondTrend({channel},...
            startgps,...
            duration,...
            serverstring,...
            serverchannels);
        
        %     assignin('base', 'aaout', aa);

    case 'minute trends'

        aa = NDS_GetMinuteTrend({channel},...
            startgps,...
            duration,...
            serverstring,...
            serverchannels);

%     assignin('base', 'aaout', aa);
    otherwise

        error('### unknown data type');

end

% Convert to double and apply signal_slope
units = ldv_setunit(handles);

if strcmp(units,'Counts')
    % keep data in Counts
    x  = double(aa.data);
else
    % Convert data to Volts
    x  = double(aa.data) .* double(aa.signal_slope);
end

fs = double(aa.rate);

% do any preprocessing requested.
drawnow;

end



% END
