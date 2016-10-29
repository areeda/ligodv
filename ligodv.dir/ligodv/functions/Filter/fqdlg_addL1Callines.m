function fqdlg_addL1Callines(handles)

% FQDLG_ADDDL1CALLINES add calline frequencies to the list.
% 
% J Smith 1/4/08 copied fqdlg_addDefaultFreqs by M Hewitson 09-08-06
% 
% $Id$
% 


% get current frequency set
freqs = getappdata(handles.main, 'freqs');

% define default frequencies
dfs = [54.70 396.70 1151.50 1613.9 1618.9];
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