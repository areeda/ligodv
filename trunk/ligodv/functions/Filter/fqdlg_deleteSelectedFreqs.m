function fqdlg_deleteSelectedFreqs(handles)

% FQDLG_DELETESELECTEDFREQS delete the selected frequencies from the list.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get selected frequencies
fidx  = get(handles.fdlg_freqList, 'Value');
freqs = getappdata(handles.main, 'freqs');

% set output frequencies
freqsout.nfreqs = 0;
freqsout.f      = [];

% loop over those selected
for f=1:freqs.nfreqs
  if f ~= fidx
    freqsout.nfreqs = freqsout.nfreqs + 1;
    freqsout.f(freqsout.nfreqs) = freqs.f(f);
  end
end

setappdata(handles.main, 'freqs', freqsout);

% update list
fqdlg_setFreqsList(handles);



% END