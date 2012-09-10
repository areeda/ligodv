function fdlg_setEntryMode(handles)

% FDLG_SETENTRYMODE set the entry mode panel based on the selected mode.
% 
% M Hewitson 04-08-06
% 
% $Id$
% 

% get entry mode

emode = ldv_getselectionbox(handles.fdlg_entryMode);


% settings.fdlg.inputmodes = {'standard types', 'pole/zero edit', 'LISO mode'};

fdlg_switchEntryMode(handles, emode);


% END