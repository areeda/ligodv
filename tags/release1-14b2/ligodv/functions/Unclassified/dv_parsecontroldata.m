function channels = dv_parsecontroldata(name, data);

% DV_PARSECONTROLDATA Parse the control data channel name and corresponding 
% data vector.
% 
% Usage: channels = dv_parsecontroldata(name, data);
%
% Input form:
% 
% channel = "top_level#sub_level_1#N#ch1#...#chN#sub_level_2#..."
%   
% Output form:
% 
% channels(1).name  = "top_level:sub_level_1:ch1"
% channels(2).name  = "top_level:sub_level_1:ch2"
%                 :
%                 :
%   
% with the corresponding data values stored in
% 
% channels(1).data
% channels(2).data
%    :
%    
%    
% M Hewitson  30-07-06
% 
% $Id$
% 

% control data is sampled at 1Hz for now
fs = 1;
count = 1;

% parse the input string
% get first part as top level
[toplevel, r] = strtok(name, '#');
name = r;
ch = 1;
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
    channels(ch).name = [toplevel ':' sublevel ':' subsublevel ];
    ch = ch + 1;
  end
end

ch = ch-1;
    
if(ch>0)
  count = 1;
  samplespersec = ch*fs;
  numsecs = length(data)/samplespersec;

  for s=1:numsecs
	  for c=1:ch
        for i=1:fs
          channels(c).data(i+s-1) = data(count);
          count = count + 1;
        end
	  end
  end
end
