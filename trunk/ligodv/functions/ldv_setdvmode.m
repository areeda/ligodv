function ldv_setdvmode(handles)

% Set the data viewer data retrieval mode
% - switch on the relevant panels
%
%
% M Hewitson 24-07-06
%
% $Id$
%

% get settings
settings = getappdata(handles.main, 'settings');
dblevel  = settings.general.debugLevel;

% get the selected data retrieval mode
dvmode  = ldv_getselectionbox(handles.dvmode);

% Switch things based on selected data retrieval mode
switch dvmode

    % LIGO NDS Server mode
    case 'NDS Server'
        
        ndsserver(handles, 'on');
        framefile(handles, 'off');

        % enable relevant features
        %set(handles.getLatestBtn, 'Enable', 'on');
        set(handles.startSetLatestBtn, 'Enable', 'on');
        set(handles.stopSetLatestBtn, 'Enable', 'on');

    case 'NDS2 Server'

        ndsserver(handles, 'on');
        framefile(handles, 'off');

        % enable relevant features
        %set(handles.getLatestBtn, 'Enable', 'on');
        set(handles.startSetLatestBtn, 'Enable', 'on');
        set(handles.stopSetLatestBtn, 'Enable', 'on');

        %         % LDR server mode
        %     case 'LDR Server'
        %         ldv_disp('+ switching to %s mode', dvmode);
        %         framefile(handles,'on');
        %         ligoserver(handles,'off');
        %
        %
        %         % Frame file mode
        %     case 'Frames off disk'
        %         ldv_disp('+ switching to %s mode', dvmode);
        %         geoserver(handles, 'off');
        %         framefile(handles, 'on');
        %         % set defualt frame dir
        %         try
        %             ldv_loadCache(handles, settings.ff.defaultCache);
        %         catch
        %             dv_disp('# default cache file not found');
        %         end
        %         % we can't use some things in this mode
        %         set(handles.getLatestBtn, 'Enable', 'off');
        %         set(handles.startSetLatestBtn, 'Enable', 'off');
        %         set(handles.stopSetLatestBtn, 'Enable', 'off');

    otherwise
        error('unknown data server mode');
end

end

% END

% set ligo server  state
function ndsserver(handles, state)

% set server info panel to visible
set(handles.serverInfoPanel, 'visible', state);

end

% set frame file state
function framefile(handles, state)

% set frame file info panel to visible
set(handles.framefileInfoPanel, 'visible', state);

end
