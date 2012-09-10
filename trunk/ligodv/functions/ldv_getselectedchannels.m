function channels = ldv_getselectedchannels(handles)

% LDV_GETSELECTEDCHANNELS get a list of the selected channels from the
% channel list box.
%
% M Hewitson 26-07-06
%
% $Id$

idx = get(handles.channelList, 'Value');
list = get(handles.channelList, 'String');

%% old method before adding sr to list

% channels = deblank(list(idx,:)); 
channels=cell(0,1);

if (isempty(idx))
    msgbox('No Channels are selected','Get Data Error','error');
elseif length(list) == 1 & strcmp(list(1),'-') 
    msgbox('Channel list is empty, did you forget to query server', 'Get Data Error', 'error');
else
    %% new method to remove sample rate form channel names 

    for i = 1:length(idx)

        channels(i) = cellstr(deblank(regexprep(list(idx(i),:),'\((\w*)\)','')));

    end

    channels = char(channels);
end
% assignin('base', 'channels_test', channels); % export chans variable

% END