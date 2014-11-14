function channels = ldv_getselectedchannels(handles)

% LDV_GETSELECTEDCHANNELS get a list of the selected channels from the
% channel list box.
%
% M Hewitson 26-07-06
%
% $Id$

idx = get(handles.channelList, 'Value');
list = get(handles.channelList, 'String');

if (isempty(idx) ||  (length(list) == 1 && strcmp(list(1),'-')) )
    channels = {}; 
else
    %% new method to remove sample rate form channel names 

    for i = 1:length(idx)

        channels(i) = cellstr(deblank(regexprep(list(idx(i),:),'\((\w*)\)','')));

    end

    channels = char(channels);
end
