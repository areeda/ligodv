function newtimes = tdlg_loadList(handles)

% TDLG_LOADLIST load a list of times from a text file.
%
% M Hewitson 16-11-06
%
% $Id$
%

% get current times
times = getappdata(handles.main, 'times');

[filename, pathname] = uigetfile('*.txt', 'Txt-file input');
infilename = [pathname filename];
if isequal(filename,0)|isequal(pathname,0)
  error('### File not found');
else
  fid = fopen(infilename, 'r');
  while(~feof(fid))
    l = fgetl(fid);
    times.ntimes = times.ntimes+1;
    [t,r] = strtok(l, ' ');
    % first comes yy-mm-dd or gps time
    str   = deblank(t); 
    idx = strfind(t, '-');    
    if length(idx)==2
      yymmdd = char(str);      
      [t,r] = strtok(r, ' ');
      % now comes hh:mm:ss
      hhmmss = deblank(t);
      tin = [yymmdd ' ' hhmmss];
      times.t(times.ntimes).startgps = ldv_utc2gps(tin);
    else
      tin = char(str);
      times.t(times.ntimes).startgps = str2num(tin);
    end
    
    % now we get nsecs and rest is comment
    [t,r] = strtok(r, ' ');
    nsecs = str2num(deblank(t));
    comm  = char(deblank(r));

    times.t(times.ntimes).stopgps = times.t(times.ntimes).startgps+nsecs-1;
    times.t(times.ntimes).comment = comm;
  end
  fclose(fid);


end

newtimes = times