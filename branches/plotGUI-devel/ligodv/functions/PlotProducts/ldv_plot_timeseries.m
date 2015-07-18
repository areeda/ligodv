function ldv_plot_timeseries(handles)

% LDV_PLOT_TIMESERIES Make a time-series plot of the selected data
% objects.
%
% M Hewitson
%
% $Id$
%
%

% settings
ldv_settings = getappdata(handles.main, 'ldv_settings');
colors   = ldv_settings.general.colors;
Ncols    = length(colors);


% get the selected data objects
dobjsidx = ldv_getselecteddobjs(handles);
dobjs    = getappdata(handles.main, 'dobjs');
nobjs    = length(dobjsidx);

% get math string
mathstr = get(handles.plotTimeSeriesMathTxt, 'String');
if isempty(mathstr)
    mathstr = 'u';
end

% time average?
timeAverage =  get(handles.plotTimeSeriesAvChk, 'Value');
avLengthStr =  get(handles.plotTimeSeriesAvLength, 'String');
if isempty(avLengthStr)
    avLength = 1.0;
else
    avLength = str2double(avLengthStr);
end

% plot configuration
plotcfg = ldv_getselectionbox(handles.plotTimeSeriesPlots);

% if we want stacked or subplots, we need a figure now
if strcmp(plotcfg, 'stacked') || strcmp(plotcfg, 'subplots')
    hfig = figure;
    % set figure title
    set(hfig, 'Name', ['ligoDV plot objects: ' sprintf('%d, ', dobjs.objs(dobjsidx).id)]);
end

% get x-limits
xlimStr = get(handles.plotXlims, 'String');
eval(sprintf('xlims = [%s];', xlimStr));
% get y-limits
ylimStr = get(handles.plotYlims, 'String');
eval(sprintf('ylims = [%s];', ylimStr));
% link axes?
link = get(handles.plotLinkChk, 'Value');

% data store
dvout = [];

% determine the scale for the time axis and the time-origin
useHours = 0;
useDays  = 0;
pt0      = 0;
for ob=1:nobjs
    % get current object
    obj = dobjs.objs(dobjsidx(ob));

    maxt = length(obj.data.x)/obj.data.fs;
    if maxt > 3600
        useHours = 1;
    end
    if maxt > 86400
        useDays = 1;
    end

end

% get unit for y-axis
unit = ldv_getYunits(handles);
% unit = get(handles.plotUnitTxt, 'String');

% go through each object
legendStr = [];
for ob = 1:nobjs

    % get current object
    obj = dobjs.objs(dobjsidx(ob));

    % prepare data
    [t, x, info] = ldv_preparedata(obj, handles);

    % apply math commands
    eval(sprintf('x=%s;', strrep(mathstr, 'u', 'x')));

    % time average?
    xlab = 'Time [s]';
    if timeAverage
        [t, x] = ldv_timeAverage(t, x, info.fs, avLength);
    else
        if useHours
            t = t / 3600;
            xlab = 'Time [h]';
            if useDays
                t = t / 24;
                xlab = 'Time [d]';
            end
        end

    end

    % switch through different plot configurations
    switch plotcfg
        case 'single'

            hfig = figure;
            if  info.fs<=1 %strcmp(params.dtype, 'second trends') || strcmp(params.dtype, 'minute trends')
                h = stairs(t,x);
            else
                h = plot(t, x);
            end
            title('Time-series plot');
            h = legend(ldv_buildlegend(obj, 'timeseries'));
            set(h, 'FontSize', 10)
            set(hfig, 'Name', sprintf('ligoDV plot object: %s', obj.channel));
            ylab = ['Amplitude', ' [',obj.data.unitY,']'];

        case 'stacked'

            if  info.fs<=1 %strcmp(params.dtype, 'second trends') || strcmp(params.dtype, 'minute trends')
                h = stairs(t,x);
            else
                h = plot(t, x);
            end
            title('Time-series plot');
            hold on;
            col = colors{mod(ob-1,Ncols)+1};
            set(h, 'Color', col);
            legendStr = [legendStr ldv_buildlegend(obj, 'timeseries')];
            ylab = ['Amplitude', ' [',unit,']'];

        case 'subplots'

            sp(ob) = subplot(nobjs, 1, ob);
            if  info.fs<=1 %strcmp(params.dtype, 'second trends') || strcmp(params.dtype, 'minute trends')
                h = stairs(t,x);
            else
                h = plot(t, x);
            end
            hold on;
            h = legend(ldv_buildlegend(obj, 'timeseries'));
            set(h, 'FontSize', 10)
            ldv_suptitle('Time-series plot');
            ylab = ['Amplitude', ' [',obj.data.unitY,']'];

        otherwise
            error('### unknown plot configuration');
    end   % end of plot config switch

    
    % set plot defaults
    grid on;
    xlabel(xlab);
    ylabel(ylab);
    ldv_xaxis(hfig, xlims)
    ldv_yaxis(hfig, ylims)

    % add to output data
    dvout.type            = 'Timeseries';
    dvout.obj(ob).channel = obj.channel;
    dvout.obj(ob).info    = info;
    dvout.obj(ob).t       = t;
    dvout.obj(ob).x       = x;

end  % end of obj loop

% set legend if plots are stacked
if strcmp(plotcfg, 'stacked')
    h = legend(legendStr);
    set(h, 'FontSize', 10)
end

% link x-axes for subplots
if strcmp(plotcfg, 'subplots')
    if link
        linkaxes(sp,'x');
    end
end

% save output data
if get(handles.plotSaveChk, 'Value')
    ldv_dataProductSave(dvout)
end

% export output data
if get(handles.plotExportChk, 'Value')
    ldv_dataProductExport(dvout)
end


