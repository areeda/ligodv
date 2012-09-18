function fdlg_setStandardType(handles)

% FDLG_SETSTANDARDTYPE setup for the selected standard filter type.
% 
% M Hewitson 08-08-06
% 
% $Id$
% 

type = ldv_getselectionbox(handles.fdlg_inputStandardTypes);

fdlg_switchStandardType(handles, type);



% END