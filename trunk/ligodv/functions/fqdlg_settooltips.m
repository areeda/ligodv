function fqdlg_settooltips(handles)

% FQDLG_SETTOOLTIPS set the tooltips for the frequencies dialog.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

%% Enter frequencies

% Add H1 Callines
tip = sprintf('Add the calibration line frequencies for H1 to the list.');
set(handles.fdlg_addH1Btn, 'TooltipString', tip);

% Add H2 Callines
tip = sprintf('Add the calibration line frequencies for H2 to the list.');
set(handles.fdlg_addH2Btn, 'TooltipString', tip);

% Add L1 Callines
tip = sprintf('Add the calibration line frequencies for L1 to the list.');
set(handles.fdlg_addL1Btn, 'TooltipString', tip);

% add
tip = sprintf('Add the input frequency to the list.');
set(handles.fdlg_addBtn, 'TooltipString', tip);

% f0
tip = sprintf('Enter the fundamental frequency for a harmonic series.');
set(handles.fqdlg_f0, 'TooltipString', tip);

% N
tip = sprintf('Enter the length of the harmonic series.');
set(handles.fqdlg_Nf, 'TooltipString', tip);

% add harmonics
tip = sprintf('Add a harmonic series to the list of frueqencies.');
set(handles.fdlg_addHarmonicsBtn, 'TooltipString', tip);


%% Frequency list

% delete
tip = sprintf('Delete selected frequencies from the list.');
set(handles.fdlg_deleteBtn, 'TooltipString', tip);

% clear
tip = sprintf('Clear all frequencies from the list.');
set(handles.fdlg_clearListBtn, 'TooltipString', tip);



%% Controls

% close
tip = sprintf('Close dialog box and return list of\nfrequencies to the dataviewer.');
set(handles.fdlg_closeBtn, 'TooltipString', tip);



% END