function handles = fdlg_init(handles)

% FDLG_INIT initialisation function for the filter dialog box.
% 
% M Hewitson 04-08-06
% 
% $Id$
% 

% get settings
ldv_settings = getappdata(handles.main, 'ldv_settings');

%% set drop-down menus

% input mode
set(handles.fdlg_entryMode, 'String', ldv_settings.fdlg.inputmodes);
set(handles.fdlg_entryMode, 'Value', 1);
fdlg_setEntryMode(handles);

% Fs select
set(handles.fdlg_fsSelect, 'String', ldv_settings.fdlg.viewfs);
set(handles.fdlg_fsSelect, 'Value', 1);


%% Standard input mode

set(handles.fdlg_inputStandardTypes, 'String', {'lowpass', 'highpass', 'bandpass', 'bandreject'});
set(handles.fdlg_inputStandardTypes, 'Value', 2);
fdlg_setStandardType(handles);

set(handles.fdlg_inputStandardF1, 'String', '150');
set(handles.fdlg_inputStandardF2, 'String', '250');
set(handles.fdlg_inputStandardOrder, 'String', '4');

% END