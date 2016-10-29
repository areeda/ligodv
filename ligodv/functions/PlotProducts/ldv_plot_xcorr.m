function ldv_plot_xcorr(handles)

% lDV_PLOT_XCORR Make a cross-correlation plot of the selected data
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

% check what is selected
if nobjs < 1
  error('### please select at least one data object for an auto-correlation plot.');
end


% get scale options
scaleopt = ldv_getselectionbox(handles.plotXCorrScaleopts);

% autocorrelation?
autocorr = get(handles.plotXCorrAuto, 'Value');
if autocorr
  pobj.id = -1;
  px      = [];
  pt      = [];
  pfs     = 0;
  pt0     = -1;
else
  if nobjs < 2
    error('### please select at least two data objects for a cross-correlation plot.');
  end
  % get the primary object
  pobj = ldv_getprimaryobject(dobjs, handles.plotXCorrPrimaryChan);
  [pt, px, pinfo] = ldv_preparedata(pobj, handles);
end

% plot configuration
plotcfg = ldv_getselectionbox(handles.plotXCorrPlots);

% correct for filtering
correctFiltering = get(handles.dv_correctFilters, 'Value');

% mark spectral frequencies?
markFreqs = get(handles.plotSpectrumMarkFreqs, 'Value');
freqs     = getappdata(handles.main, 'freqs');

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
if autocorr
  ctitle = sprintf('Auto-correlation plot');
else
  ctitle = xcorrTitle(pobj);
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

% loop through plot objects
pn = 1;
for ob = 1:nobjs

  % get current object
  obj = dobjs.objs(dobjsidx(ob));
  
  % ignore primary object
  if obj.id ~= pobj.id
    
    % prepare data
    [t, x, dinfo] = ldv_preparedata(obj, handles);

    % compute coherence
    [lags, cxy, info] = ldv_xcorr('XCORR', x, px, scaleopt, obj.data.fs);

    % object info
    obj.info = structcat(info, dinfo);

    % labels
    xlab = 'Time-lag [s]';
    ylab = 'Cross-correlation';

    % switch through different plot configurations
    switch plotcfg
      case 'single'

        hfig = figure;
        h = plot(lags, cxy);
        hold on;
        title(ctitle);
        legendStr = ldv_buildlegend(obj, 'xcorr');
        set(hfig, 'Name', sprintf('ligoDV plot object: %s', obj.channel));

        % add legend
        h = legend(legendStr);
        set(h, 'FontSize', 10)

      case 'stacked'

        h = plot(lags, cxy);
        title(ctitle);
        hold on; grid on;
        col = colors{mod(pn-1,Ncols)+1};
        set(h, 'Color', col);
        legendStr = [legendStr ldv_buildlegend(obj, 'xcorr')];

      case 'subplots'

        sp(ob) = subplot(nobjs-1, 1, pn);
        h = plot(lags, cxy);
        hold on;
        legendStr = ldv_buildlegend(obj, 'xcorr');
        
        ldv_suptitle(ctitle);

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
    dvout.type               = sprintf('Cross-correlation'); % with %s', pobj.channel);
    dvout.obj(pn).channel    = obj.channel;
    dvout.obj(pn).info       = obj.info;
    dvout.obj(pn).lags       = lags;
    dvout.obj(pn).cxy        = cxy;
    
    % plot counter
    pn = pn + 1;
  end % end of if ~ primary 
end  % end of obj loop

% set legend if this is a subplot or stacked
if strcmp(plotcfg, 'stacked')
  h = legend(legendStr);
  set(h, 'FontSize', 10)
end

% link x-axes for subplots
if strcmp(plotcfg, 'subplots')
    if link
        linkaxes(sp(2:length(sp)),'x');
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% XCorr title
% 
function str = xcorrTitle(obj)

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

legendStr = sprintf('%02d: %s\nfs = %d : %ds from %s - %s',...
      obj.id, strrep(obj.channel, '_', '\_'),...
      obj.data.fs, nsecs, ...
      ldv_gps2utc(startgps), obj.comment);
if obj.preproc.heterodyneOn
  legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
end

str = [sprintf('Cross-correlation plot\n')  legendStr];

     
     
     
