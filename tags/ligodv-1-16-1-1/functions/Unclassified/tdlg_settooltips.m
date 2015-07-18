function tdlg_settooltips(handles)

% TDLG_SETTOOLTIPS set the tooltips for the time dialog box.
% 
% M Hewitson 03-08-06
% 
% $Id$
% 

%% Edit panel

% UTC start input
tip = sprintf('Input the start time in UTC format\n "yyyy-mm-dd HH:MM:SS", e.g. 2006-05-04 11:23:56..');
set(handles.tdlg_utcStart, 'TooltipString', tip);

% UTC stop input
tip = sprintf('Input the stop time in UTC format\n "yyyy-mm-dd HH:MM:SS", e.g. 2006-05-04 11:23:56.');
set(handles.tdlg_utcStop, 'TooltipString', tip);

% GPS start input
tip = sprintf('Input the start time in GPS format,\ne.g. 799876543.');
set(handles.tdlg_gpsStart, 'TooltipString', tip);

% GPS stop input
tip = sprintf('Input the stop time in GPS format,\ne.g. 799876543.');
set(handles.tdlg_gpsStop, 'TooltipString', tip);

% comment field
tip = sprintf('Enter a comment to be associated\nwith the single time entered.');
set(handles.tdlg_comment, 'TooltipString', tip);

% last day button
tip = sprintf(['Make a list of times spanning the 24 hours prior to the\ncurrently entered time.' ...
               'Times are spaced by 1 hour.']);
set(handles.tdlg_lastDayBtn, 'TooltipString', tip);

% last hour button
tip = sprintf(['Make a list of times spanning the hour prior to the\ncurrently entered time.' ...
               'Times are spaced by 10 minutes.']);
set(handles.tdlg_lastHourBtn, 'TooltipString', tip);

% add button
tip = sprintf('Add the currently entered time to the list.');
set(handles.tdlg_addBtn, 'TooltipString', tip);


%% Times list panel

% save list
tip = sprintf('Save the times list to a .txt file.');
set(handles.tdlg_saveList, 'TooltipString', tip);

% load list
tip = sprintf('Load the times list from a .txt file.');
set(handles.tdlg_loadList, 'TooltipString', tip);


% delete selected
tip = sprintf('Delete the selected times from the list.');
set(handles.tdlg_deleteSelectedBtn, 'TooltipString', tip);

% clear all
tip = sprintf('Clear all times from the list.');
set(handles.tdlg_clearListBtn, 'TooltipString', tip);


%% Controls panel

% close
tip = sprintf('Close the dialog box and return the list of times to the dataviewer.');
set(handles.tdlg_closeBtn, 'TooltipString', tip);



% END