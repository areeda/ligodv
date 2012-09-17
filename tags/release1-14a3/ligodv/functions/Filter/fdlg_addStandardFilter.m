function fdlg_addStandardFilter(handles)

% FDLG_ADDSTANDARDFILTER add a standard filter to the filters structure.
% 
% M Hewitson 
% 
% $Id$
% 

% get existing filters
filters = getappdata(handles.main, 'filters');

% get selection details
ftype = ldv_getselectionbox(handles.fdlg_inputStandardTypes);
f1    = str2double(get(handles.fdlg_inputStandardF1, 'String'));
f2    = str2double(get(handles.fdlg_inputStandardF2, 'String'));
order = str2double(get(handles.fdlg_inputStandardOrder, 'String'));
gain  = str2double(get(handles.fdlg_inputStandardGain, 'String'));

% some more checks
if strcmp(ftype, 'bandpass') || strcmp(ftype, 'bandreject')
  if f2<=f1
    error('### stop frequency must be greater than start frequency');
  end
end

if strcmp(ftype, 'lowpass') || strcmp(ftype, 'highpass')
  f2 = 0;
end


% add filter description
filters.nfilts = filters.nfilts + 1;
filters.filt(filters.nfilts).type  = ftype;
filters.filt(filters.nfilts).f     = [f1 f2];
filters.filt(filters.nfilts).order = order;
filters.filt(filters.nfilts).gain  = gain;


% add to filter structure
setappdata(handles.main, 'filters', filters);

% rebuild filter list
fdlg_setFilterList(handles);

% END