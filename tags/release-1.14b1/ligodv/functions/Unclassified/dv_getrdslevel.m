function rds = dv_getrdslevel(handles)

% DV_GETRDSLEVEL returns the rds level specified in the input
% field.
% 
% M Hewitson 26-07-06
% 
% $Id$

rds = str2num(get(handles.gd_rdslevel, 'String'));


% END