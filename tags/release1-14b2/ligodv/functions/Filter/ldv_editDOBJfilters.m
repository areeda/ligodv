function filtersout = ldv_editDOBJfilters(handles)

% LDV_EDITDOBJFILTERS edit the filters for a particular data object.
%
% M Hewitson 09-08-06
%
% $Id$
%


% get the filter objects for the selected data object
didx  = ldv_getselecteddobjs(handles);
dobjs = getappdata(handles.main, 'dobjs');
filtersout.filt    = [];
filtersout.nfilts  = 0;
if dobjs.nobjs > 0 && ~isempty(didx)
    dobj  = dobjs.objs(didx);


    % make filter descriptions from filter objects
    try
        filters = ldv_filtObj2filtDesc(dobj.filters);

        % open filter dialog box
        pos_size = get(handles.main,'Position');
        dlg_pos = [pos_size(1)+pos_size(3)/5 pos_size(2)+pos_size(4)/5];

        try
            filtersout = dv_filtersDLG(dlg_pos, filters);
            % If there are no filters in the dialog box, clear filters for
            % that object
            if filtersout.nfilts == 0
                ldv_clearFilters(handles);
            end
        end

    end
end


% END