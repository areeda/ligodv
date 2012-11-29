function ldv_plot_xyscatter(handles)

% LDV_PLOT_XYSCATTER Make an XY-scatter plot of the selected data
% objects.
%
% J Smith 1/4/08
%
% $Id$
%
%

% settings
settings = getappdata(handles.main, 'settings');
colors   = settings.general.colors;

% get the selected data objects
dobjsidx = ldv_getselecteddobjs(handles);
dobjs    = getappdata(handles.main, 'dobjs');
nobjs    = length(dobjsidx);

% check what is selected
if nobjs < 2
    error('### please select at least two data objects for an XY-scatter plot.');
end

% get the primary object
pobj = ldv_getprimaryobject(dobjs, handles.plotXYscatterPrimaryChan);
[pt, px, pinfo] = ldv_preparedata(pobj, handles);

% data store
dvout = [];

% add primary object to output data
dvout.type               = sprintf('XYscatter with %s', pobj.channel);
dvout.obj(1).channel    = pobj.channel;
dvout.obj(1).info       = pinfo;
dvout.obj(1).x        = px;

% plot configuration
plotcfg = ldv_getselectionbox(handles.plotXYscatterPlots);

% correct for filtering
correctFiltering = get(handles.dv_correctFilters, 'Value');

% get unit for y-axis
% unit = get(handles.plotUnitTxt, 'String');
unit = ldv_getYunits(handles);

% if we want stacked or subplots, we need a figure now
if strcmp(plotcfg, 'stacked') || strcmp(plotcfg, 'subplots')
    hfig = figure;
    set(hfig, 'Name', ['ligoDV plot objects: ' sprintf('%d, ', dobjs.objs(dobjsidx).id)]);
end

% go through each object
legendStr = [];

% plot title
ctitle = XYscatterTitle(pobj);

% get x-limits
xlimStr = get(handles.plotXlims, 'String');
eval(sprintf('xlims = [%s];', xlimStr));
% get y-limits
ylimStr = get(handles.plotYlims, 'String');
eval(sprintf('ylims = [%s];', ylimStr));

% loop through plot objects
pn = 1;
for ob = 1:nobjs

    % get current object
    obj = dobjs.objs(dobjsidx(ob));

    % ignore primary object
    if obj.id ~= pobj.id

        % prepare data
        [t, x, dinfo] = ldv_preparedata(obj, handles);

        % object info
        obj.info = dinfo;

        % Set primary channel as x-label
        xlab = [ldv_chan2label(pobj.channel), ' [',pobj.data.unitY,']'];

        % switch through different plot configurations
        switch plotcfg
            case 'single'

                hfig = figure;
                h = scatter(px, x, 20, colors{1},'filled');
                hold on;
                title(ctitle);
                legendStr = ldv_buildlegend(obj, 'XYscatter');
                set(hfig, 'Name', sprintf('ligoDV plot object: %s', obj.channel));
                ylab = [ldv_chan2label(obj.channel), ' [',obj.data.unitY,']'];
                h = legend(legendStr);

            case 'stacked'

                h = scatter(px, x, 20, colors{pn},'filled');

                title(ctitle);
                hold on; grid on;
                ylab = ['Secondary Channel', ' [',unit,']'];
                legendStr = [legendStr ldv_buildlegend(obj,'XYscatter')];

            case 'subplots'

                subplot(nobjs-1, 1, pn)
                h = scatter(px, x, 20, colors{1},'filled');
                hold on;
                legendStr = ldv_buildlegend(obj, 'XYscatter');
                ldv_suptitle(ctitle);
                ylab = [ldv_chan2label(obj.channel), ' [',obj.data.unitY,']'];
                % add legend
                h = legend(legendStr);
                set(h, 'FontSize', 10)

            otherwise
                error('### unknown plot configuration');

        end   % end of plot config switch

        % add labels and grid
        grid on;
        xlabel(xlab);
        ylabel(ylab);

        ldv_xaxis(hfig, xlims)
        ldv_yaxis(hfig, ylims)

        % add to output data
        dvout.type               = sprintf('XYscatter with %s', pobj.channel);
        dvout.obj(pn+1).channel    = obj.channel;
        dvout.obj(pn+1).info       = obj.info;
        dvout.obj(pn+1).x        = x;

        % plot counter
        pn = pn + 1;
    end % end of if ~ primary
end  % end of obj loop

% set legend if this is a subplot or stacked
if strcmp(plotcfg, 'stacked')
    h = legend(legendStr);
    set(h, 'FontSize', 10)
end

% save output data
if get(handles.plotSaveChk, 'Value')
    ldv_dataProductSave(dvout)
end

% export output data
if get(handles.plotExportChk, 'Value')
    ldv_dataProductExport(dvout)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% XYscatter title
%
function str = XYscatterTitle(obj)

% get settings
includingPrime = obj.data.includingPrime;

% set start and stop
if includingPrime > 0
    startgps = obj.startgps + includingPrime;
else
    startgps = obj.startgps;
end
stopgps  = obj.stopgps;
nsecs    = stopgps - startgps;

% additional info tag
switch obj.source.type
    case {'hour trends', 'day trends'}

    otherwise
        tag = '';
end

legendStr = sprintf('\nPrimary = %02d: %s\nfs = %d : %ds from %s - %s',...
    obj.id, strrep(obj.channel, '_', '\_'),...
    obj.data.fs, nsecs, ...
    ldv_gps2utc(startgps), obj.comment);

if obj.preproc.heterodyneOn
    legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
end
str = ['XY-scatter plot: ',  legendStr];



