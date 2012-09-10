function control_channels = dv_parsecontrolchans(channels)

% DV_PARSECONTROLCHANS parse out a list of control channels from the input
% channel list.
% 
% Usage:  control_channels = dv_parsecontrolchans(chanlist);
%
% Input form:
% 
% channel = "top_level#sub_level_1#N#ch1#...#chN#sub_level_2#..."
%   
% Output form:
% 
% channels(1)  = "top_level:sub_level_1:ch1"
% channels(2)  = "top_level:sub_level_1:ch2"
%                 :
%                 :
% 
% 
% M Hewitson 26-07-06
% 
% $Id$


% control data is sampled at 1Hz for now
count = 1;

numtoplevels = length(channels(:,1));

ch = 1;
control_channels = [];
for top=1:numtoplevels

  name = channels(top,:);
  if(length(name)>40)

    % parse the input string
    % get first part as top level
    [toplevel, r] = strtok(name, '#');
    name = r;
    while(length(name) > 1)

      % get sub level
      [sublevel, r] = strtok(name, '#');
      name = deblank(r);

      % get the number of sub sub levels
      [strN, r] = strtok(name, '#');
      name = deblank(r);
      % convert strN
      N = eval(strN);
      % now get each sub sub level making channel
      % names as we go and extracting data as we go
      for s = 1:N
        [subsublevel, r] = strtok(name, '#');
        name = deblank(r);
        control_channels = strvcat(control_channels,[toplevel ':' sublevel ':' subsublevel ]);
        ch = ch + 1;
      end
    end
  end
end

ch = ch-1;



% END

