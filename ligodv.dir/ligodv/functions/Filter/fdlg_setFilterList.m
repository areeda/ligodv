function fdlg_setFilterList(handles)

% FDLG_SETFILTERLIST builds descriptions strings for entered filters and
% adds them to the filter list.
%
% M Hewitson 08-08-06
%
% $Id$
%

% get filters
filters = getappdata(handles.main, 'filters');

filtersstr = [];
for n=1:filters.nfilts
    filt = filters.filt(n); 
    % build description strings the type of filter in question
    switch filt.type
        case 'pzmodel'
            fstr = sprintf('g=%d, np=%d,  nz=%d,  %s', filt.gain, filt.npoles, filt.nzeros, filt.type);
            filtersstr = strvcat(filtersstr, fstr);
        case 'lowpass'
            fstr = sprintf('g=%d, ord=%d, fc=%d, %s', filt.gain, filt.order, filt.f(1), filt.type);
            filtersstr = strvcat(filtersstr, fstr);
        case 'highpass'
            fstr = sprintf('g=%d, ord=%d, fc=%d, %s', filt.gain, filt.order, filt.f(1), filt.type);
            filtersstr = strvcat(filtersstr, fstr);
        case 'bandpass'
            fstr = sprintf('g=%d, ord=%d, f1=%d, f2=%d, %s', filt.gain, filt.order, filt.f(1), filt.f(2), filt.type);
            filtersstr = strvcat(filtersstr, fstr);
        case 'bandreject'
            fstr = sprintf('g=%d, ord=%d, f1=%d, f2=%d, %s', filt.gain, filt.order, filt.f(1), filt.f(2), filt.type);
            filtersstr = strvcat(filtersstr, fstr);
        otherwise
            error('### unknown filter type');
    end
end

% Display the filter description strings in list
if filters.nfilts == 0
    set(handles.fdlg_filterList, 'String', '  ');
else
    set(handles.fdlg_filterList, 'String', filtersstr);
end
set(handles.fdlg_filterList, 'Value', 1);


% END