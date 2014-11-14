function fqdlg_setFreqsList(handles)

% FQDLG_SETFREQSLIST set the list of frequencies to the structure of
% frequencies.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get frequencies
freqs = getappdata(handles.main, 'freqs');

freqsstr = [];
for n=1:freqs.nfreqs
      
  % get this time
  f        = freqs.f(n);
  
  % build display string
  fstr = sprintf('%2.2f', f);
  freqsstr = strvcat(freqsstr, fstr);  
  
end

if freqs.nfreqs == 0
  set(handles.fdlg_freqList, 'String', '  ');
else
  set(handles.fdlg_freqList, 'String', freqsstr);
end
set(handles.fdlg_freqList, 'Value', 1);





% END