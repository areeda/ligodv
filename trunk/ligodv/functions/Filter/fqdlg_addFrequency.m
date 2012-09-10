function fqdlg_addFrequency(handles)

% FQDLG_ADDFREQUENCY add frequency to list.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get entered frequency
fstr = get(handles.fdlg_fInput, 'String');

if isempty(fstr)
  f = 0;
else
  f = str2num(fstr);
end

% get current frequency set
freqs = getappdata(handles.main, 'freqs');

% add new frequency
freqs.nfreqs = freqs.nfreqs+1;
freqs.f(freqs.nfreqs) = f;
setappdata(handles.main, 'freqs', freqs);

% update list
fqdlg_setFreqsList(handles);


% END