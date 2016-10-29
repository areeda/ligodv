function ldv_getdataobject(handles)

% LDV_GETDATAOBJECT get a data object from the specified input fields.
%
% M Hewitson 26-07-06
%
% $Id$

    % first see if there's anything to do
    channels = ldv_getselectedchannels(handles);
    if (isempty(channels))
        ldvMsgbox('Channel list is empty or none selected.', 'Get Data Error', 'error');
    else
        % get the data retrieval mode
        dvmode = ldv_getselectionbox(handles.dvmode);

        switch dvmode

            case {'NDS Server', 'NDS2 Server'}

                ldv_getDataObjects(handles);

            case 'LDR Server'

                dv_getFrameDataObjects(handles);

            otherwise
                error('### unknown data retrieval mode');
        end
    end
end