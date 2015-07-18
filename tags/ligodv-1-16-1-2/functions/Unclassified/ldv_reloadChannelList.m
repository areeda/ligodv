function ldv_reloadChannelList(handles)

% LDV_RELOADCHANNELLIST reload channel list from memory.
%
% J Smith 5/8/08
%
% $Id$

% get the data retrieval mode
dvmode = ldv_getselectionbox(handles.dvmode);

% get full channel list from memory
channels = getappdata(handles.main, 'FullChannelList');

% if we reloaded a saved channel list but never queried the server
% we have to do the query now
if (isempty(channels))
    vals = chanFilter();
  
    disp(vals);
    if (strcmpi(vals.cmd,'search'))
        ldv_getChannelList2(handles,vals);
    end
    
    channels = getappdata(handles.main, 'FullChannelList');
end


if strcmp(dvmode,'NDS Server')
% get rid of test point channels (only useful for real time display)
idx = find([channels(:).tpnum] == 0); % tpnum>1 for test point chans
channels = channels(idx);
end

% export chans variable
assignin('base', 'channels_raw', channels);

for j = 1:length(channels)
    namestr = char(channels(j).name);
    rate = channels(j).rate;
    liststr{j} = sprintf('%-33s (%d)', namestr, rate);
end

% make string list of channels
channels = char(liststr);

% export chans variable
assignin('base', 'channels_final', channels);

ldv_disp('*** Reloaded %d channels from memory', length(channels));
% Set list fields
set(handles.channelList, 'String', channels);
set(handles.channelList, 'Value', 1);