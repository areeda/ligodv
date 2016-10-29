function fqdlg_clearFreqs(handles)

% FQDLG_CLEARFREQS clear all frequencies from the list.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

freqs.nfreqs = 0;
freqs.f      = [];

setappdata(handles.main, 'freqs', freqs);

% update list
fqdlg_setFreqsList(handles);


% END