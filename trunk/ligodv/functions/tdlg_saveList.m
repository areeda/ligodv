function tdlg_saveList(handles)

% TDLG_SAVELIST save the list of times to a text file.
% 
% M Hewitson 16-11-06
% 
% $Id$
% 

% get current times structure
times = getappdata(handles.main, 'times');

% save list
if times.ntimes > 0
  
  %% Get filename
  [filename, pathname] = uiputfile('*.txt', 'Txt-file output');
  outfilename = [pathname filename];
  if ~isempty(outfilename)
    fid = fopen(outfilename,'w+');
    for j=1:times.ntimes
      nsecs = times.t(j).stopgps - times.t(j).startgps+1;
      fprintf(fid, '%s  %d  %s\n', ldv_gps2utc(times.t(j).startgps), nsecs, times.t(j).comment);
    end
    fclose(fid);
  end
else
  error('### Add some times to the list first.');  
end


% END