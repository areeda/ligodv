function R = ldv_getresamplefactor(handles)

% LDV_GETRESAMPLEFACTOR get the resample factor from the selected value.
% 
% M Hewitson 28-07-06
% 
% $Id$
% 

rstr = ldv_getselectionbox(handles.preprocResampleR);
eval(sprintf('R = 1/(%s);', rstr));

% END