function fdlg_switchStandardType(handles, type)

% FDLG_SWITCHSTANDARDTYPE swith the standard filter type.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get possible types
types = get(handles.fdlg_inputStandardTypes, 'String');

% get index
idx = strmatch(type, types);

set(handles.fdlg_inputStandardTypes, 'Value', idx);

switch type
  case 'lowpass'

    % F1 input
    set(handles.fdlg_inputStandardF1Label, 'String', 'corner frequency');
    set(handles.fdlg_inputStandardF1, 'Enable', 'on');

    % F2 input
    set(handles.fdlg_inputStandardF2Label, 'String', '');
    set(handles.fdlg_inputStandardF2, 'Enable', 'off');

  case 'highpass'

    % F1 input
    set(handles.fdlg_inputStandardF1Label, 'String', 'corner frequency');
    set(handles.fdlg_inputStandardF1, 'Enable', 'on');

    % F2 input
    set(handles.fdlg_inputStandardF2Label, 'String', '');
    set(handles.fdlg_inputStandardF2, 'Enable', 'off');

  case 'bandpass'

    % F1 input
    set(handles.fdlg_inputStandardF1Label, 'String', 'start frequency');
    set(handles.fdlg_inputStandardF1, 'Enable', 'on');

    % F2 input
    set(handles.fdlg_inputStandardF2Label, 'String', 'stop frequency');
    set(handles.fdlg_inputStandardF2, 'Enable', 'on');

  case 'bandreject'

    % F1 input
    set(handles.fdlg_inputStandardF1Label, 'String', 'start frequency');
    set(handles.fdlg_inputStandardF1, 'Enable', 'on');

    % F2 input
    set(handles.fdlg_inputStandardF2Label, 'String', 'stop frequency');
    set(handles.fdlg_inputStandardF2, 'Enable', 'on');


  otherwise
    error('### unknown filter type');
end





% END