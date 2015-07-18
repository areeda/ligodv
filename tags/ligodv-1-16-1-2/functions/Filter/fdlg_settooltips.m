function fdlg_settooltips(handles)

% FDLG_SETTOOLTIPS set the tooltips for the filter dialog box.
% 
% M Hewitson 03-08-06
% 
% $Id$
% 


%% Edit filters

% entry mode
tip = sprintf('Choose the entry mode for new filters.');
set(handles.fdlg_entryMode, 'TooltipString', tip);

%------------------- standard types 

% filter type
tip = sprintf('Choose the standard filter type.');
set(handles.fdlg_inputStandardTypes, 'TooltipString', tip);

% f1 
tip = sprintf('Enter the lower corner frequency.');
set(handles.fdlg_inputStandardF1, 'TooltipString', tip);

% f2
tip = sprintf('Enter the upper corner frequency.');
set(handles.fdlg_inputStandardF2, 'TooltipString', tip);

% order
tip = sprintf('Enter the filter order.');
set(handles.fdlg_inputStandardOrder, 'TooltipString', tip);

% gain
tip = sprintf('Enter the filter gain.');
set(handles.fdlg_inputStandardGain, 'TooltipString', tip);

% add
tip = sprintf('Add the filter to the list.');
set(handles.fdlg_inputStandardAddBtn, 'TooltipString', tip);


%------------------- Pole/Zero edit


% add poles
tip = sprintf('Modify list of poles, e.g.:\nf1,Q1\nf2,Q2\n.\n.\nfn,Qn\n\n(For real poles set Q=0, or leave blank).');
set(handles.fdlg_inputPZpoles, 'TooltipString', tip);

% add poles
tip = sprintf('Modify list of zeros, e.g.:\nf1,Q1\nf2,Q2\n.\n.\nfn,Qn\n\n(For real zeros set Q=0, or leave blank).');
set(handles.fdlg_inputPZzeros, 'TooltipString', tip);

% gain
tip = sprintf('Set filter gain.');
set(handles.fdlg_inputPZgain, 'TooltipString', tip);

% add
tip = sprintf('Add the filter to the list.');
set(handles.fdlg_inputPZAddBtn, 'TooltipString', tip);


%% Filter list

% delete selected
tip = sprintf('Delete the selected filters from the list.');
set(handles.fdlg_deleteSelected, 'TooltipString', tip);

% clear list
tip = sprintf('Clear all filters from the list.');
set(handles.fdlg_clearList, 'TooltipString', tip);

% save filter
tip = sprintf('Save the selected filter descriptions as a MATLAB structure (.mat file).');
set(handles.fdlg_saveFilter, 'TooltipString', tip);

% load filter
tip = sprintf('Load a MATLAB structure of filter descriptions (.mat file).');
set(handles.fdlg_loadFilter, 'TooltipString', tip);

% export filter
tip = sprintf('Export the selected filter descriptions to the workspace.');
set(handles.fdlg_exportFilter, 'TooltipString', tip);

% view
tip = sprintf('Frequency response plots of selected filters for the given sample frequency.');
set(handles.fdlg_viewFilter, 'TooltipString', tip);

% Fs
tip = sprintf('Choose the sample rate to be used when viewing filter responses.');
set(handles.fdlg_fsSelect, 'TooltipString', tip);


%% Controls
tip = sprintf('Close the dialog box and return the list of\nfilter descriptions to the dataviewer.');
set(handles.fdlg_closeBtn, 'TooltipString', tip);







% END