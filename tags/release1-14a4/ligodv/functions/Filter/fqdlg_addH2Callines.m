function fqdlg_addH2Callines(handles)

% FQDLG_ADDDH2CALLINES add calline frequencies to the list.
% 
% J Smith 1/4/08 copied fqdlg_addDefaultFreqs by M Hewitson 09-08-06
% 
% $Id$
% 


% get current frequency set
freqs = getappdata(handles.main, 'freqs');

% define default frequencies
dfs = [54.10 407.30 1159.7 1622.9 1626.7];
labels = {'Cal','Cal','Cal','PhotX','PhotY'};

% add new frequency
for f=dfs
  freqs.nfreqs = freqs.nfreqs+1;
  freqs.f(freqs.nfreqs) = f;
end
setappdata(handles.main, 'freqs', freqs);

% update list
fqdlg_setFreqsList(handles);





% END