function cal = dv_getcalversion(handles)

% DV_GETCALVERSION returns the calibration version specified in the input
% field.
% 
% M Hewitson 26-07-06
% 
% $Id$

cal = str2num(get(handles.gd_calversion, 'String'));


% END