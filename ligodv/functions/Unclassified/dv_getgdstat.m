function stat = dv_getgdstat(handles)

% DV_GETGDSTAT get the statistic string for hour and day trend data from
% the selection box.
% 
% M Hewitson 31-07-06
% 
% $Id$
% 

dtype = dv_getselectionbox(handles.gd_dataTypeSelect);

switch dtype
  case {'hour trends', 'day trends'}
    stat = dv_getselectionbox(handles.gd_stat);
  otherwise
    stat = '';
end
% END