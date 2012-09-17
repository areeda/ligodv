function fqdlg_addHarmonicSeries(handles)

% FQDLG_ADDHARMONICSERIES add a harmonic series of frequencies to the list.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 


% get entered f0
f0str = get(handles.fqdlg_f0, 'String');

if isempty(f0str)
  f0 = 0;
else
  f0 = str2num(f0str);
end

% get entered Nf
Nfstr = get(handles.fqdlg_Nf, 'String');

if isempty(Nfstr)
  Nf = 0;
else
  Nf = str2num(Nfstr);
end


% get current frequency set
freqs = getappdata(handles.main, 'freqs');

for f=1:Nf
  % add new frequency
  freqs.nfreqs = freqs.nfreqs+1;
  freqs.f(freqs.nfreqs) = f*f0;
end

setappdata(handles.main, 'freqs', freqs);

% update list
fqdlg_setFreqsList(handles);



% END