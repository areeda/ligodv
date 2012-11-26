function fdlg_switchEntryMode(handles, emode)

% FDLG_SWITCHENTRYMODE changed entry mode to the desired one.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 


% set entry mode
modes = get(handles.fdlg_entryMode, 'String');

% get index for the chosen mode
idx = strmatch(emode, modes);

% set chosen mode
set(handles.fdlg_entryMode, 'Value', idx);

switch emode
  case 'standard types'

    set(handles.fdlg_inputStandard, 'Visible', 'on');
    set(handles.fdlg_inputPZEdit, 'Visible', 'off');
    set(handles.fdlg_inputLISO, 'Visible', 'off');

  case 'pole/zero edit'

    set(handles.fdlg_inputStandard, 'Visible', 'off');
    set(handles.fdlg_inputPZEdit, 'Visible', 'on');
    set(handles.fdlg_inputLISO, 'Visible', 'off');

  case 'LISO mode'

    set(handles.fdlg_inputStandard, 'Visible', 'off');
    set(handles.fdlg_inputPZEdit, 'Visible', 'off');
    set(handles.fdlg_inputLISO, 'Visible', 'on');

  otherwise
    error('### unknown filter entry mode');
end





% END