function fdlg_filterSelected(handles)

% FDLG_FILTERSELECTED this function is called when a filter is selected in
% the filter list. It does nothing if more than one filter is selected and
% sets the filter input if a single filter is selected.
%
% M Hewitson 09-08-06
%
% $Id$
%

% get selected objects
fidx = get(handles.fdlg_filterList, 'Value');

% get the full object structure
filters = getappdata(handles.main, 'filters');

% only respond to a single selected filter
if length(fidx) == 1

    % get this filter description
    filt = filters.filt(fidx);

    % decide what type of filter
    switch filt.type
        case {'lowpass', 'highpass', 'bandpass', 'bandreject'}

            % set input panel
            fdlg_switchEntryMode(handles, 'standard types');

            % set filter type
            fdlg_switchStandardType(handles, filt.type);

            % set f1, f2
            set(handles.fdlg_inputStandardF1, 'String', num2str(filt.f(1)));
            set(handles.fdlg_inputStandardF2, 'String', num2str(filt.f(2)));

            % set gain
            set(handles.fdlg_inputStandardGain, 'String', num2str(filt.gain));

            % set order
            set(handles.fdlg_inputStandardOrder, 'String', num2str(filt.order));
        
        case 'pzmodel'

            % set input panel
            fdlg_switchEntryMode(handles, 'pole/zero edit');

            % set gain
            set(handles.fdlg_inputPZgain, 'String', num2str(filt.gain));

            % set poles
            for n=1:length(filt.poles)
                if isempty(filt.poles(n).q)
                    filt.poles(n).q = 0;
                end
                p{n} = [num2str(filt.poles(n).f),',',num2str(filt.poles(n).q)];
            end
            
            try
              set(handles.fdlg_inputPZpoles, 'String', p);
            catch e  
            end
            
            %set(handles.fdlg_inputPZpoles, 'String', p);

            
            % set zeros
            for n=1:length(filt.zeros)
                if isempty(filt.zeros(n).q)
                    filt.zeros(n).q = 0;
                end
                z{n} = [num2str(filt.zeros(n).f),',',num2str(filt.zeros(n).q)];
            end
            
            try
                set(handles.fdlg_inputPZzeros, 'String', z);
            catch e
            end
            
        otherwise
            ldv_disp('!!! unknown filter type. !!!');
    end


end






% END
