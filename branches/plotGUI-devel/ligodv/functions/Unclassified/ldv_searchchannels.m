function ldv_searchchannels(handles)

% LDV_SEARCHCHANNELS search the channel list and reduce it to those that
% match the search criteria.
% 
% M Hewitson 26-07-06
% 
% $Id$

% channels
chans = get(handles.channelList, 'String');

nchans = size(chans,1);
chansout = [];

% First tokenize the search string
curr = upper(get(handles.channelSearchTxt, 'String'));
if isempty(curr)
  ldv_getChannelList(handles);
else
  
  [t, r] = strtok(curr);
  cstr = [];
  cstr = [cstr; cellstr(t)];
  while ~isempty(r)
    [t, r] = strtok(r);
    cstr = [cstr; cellstr(t)];
  end

  if strcmp(curr, '')
    chansout = chans;
  else
    for str=1:length(cstr)
      for c=1:nchans
          % Is this a match? 
        idx = strfind(upper(chans(c,:)), char(cstr(str)));
        if ~isempty(idx)
          chansout = strvcat(chansout, deblank(chans(c,:)));
        end
      end
    end
  end

  if ~isempty(chansout)
    chansout = char(sort(cellstr(chansout)));
  end

  set(handles.channelList, 'String', chansout);
  set(handles.channelList, 'Value', 1);

end


% END