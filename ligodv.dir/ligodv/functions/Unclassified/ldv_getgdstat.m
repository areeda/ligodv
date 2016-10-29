function stat = ldv_getgdstat(handles)

% DV_GETGDSTAT get the trend statistic string for hour and day trend data from
% the selection box.
% 
% J Smith 05-12-07
% 
% $Id$
% 

dtype = ldv_getselectionbox(handles.gd_dataTypeSelect);

switch dtype
  case {'second trends', 'minute trends'} % For NDS server
    stat = ldv_getselectionbox(handles.gd_stat);
  otherwise
    stat = '';
end
% END