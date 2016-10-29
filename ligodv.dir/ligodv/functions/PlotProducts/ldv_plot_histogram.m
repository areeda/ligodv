function ldv_plot_histogram(handles)

% LDV_PLOT_HISTOGRAM plot a histogram of the selected channels.
% 
% M Hewitson 30-08-06
% 
% $Id$
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
  error('### please select at least one data object for a histogram plot.');
end

% get unit for y-axis
unit = 'V'; % get(handles.plotUnitTxt, 'String');

% get bins
binsStr = get(handles.plotHistogramBins, 'String');
binsCmd = sprintf('bins = %s;', binsStr);
eval(binsCmd);


% get outlier limits
outlier = getOutliers(handles);

% de-trend?
detrend = get(handles.plotHistogramDetrend, 'Value');

% init legend 
legendStr = [];

% get unit for y-axis
% unit = get(handles.plotUnitTxt, 'String');
unit = ldv_getYunits(handles);

% plot configuration
plotcfg = ldv_getselectionbox(handles.plotHistogramPlots);

% if we want stacked or subplots, we need a figure now
if strcmp(plotcfg, 'stacked') || strcmp(plotcfg, 'subplots')
  hfig = figure;
  set(hfig, 'Name', ['ligoDV plot objects: ' sprintf('%d, ', dobjs.objs(dobjsidx).id)]);
end

% get x-limits
xlimStr = get(handles.plotXlims, 'String');
eval(sprintf('xlims = [%s];', xlimStr));
% get y-limits
ylimStr = get(handles.plotYlims, 'String');
eval(sprintf('ylims = [%s];', ylimStr));

% data store
dvout = [];

% go through each object
for ob = 1:nobjs

  % get current object
  obj = dobjs.objs(dobjsidx(ob));
  
  % prepare data
  [t, x, dinfo] = ldv_preparedata(obj, handles);
    
  % make histogram
  [x, n, info] = ldv_hist(x, bins, outlier, detrend);
  obj.info = structcat(info, dinfo);
  
  % switch through different plot configurations
  switch plotcfg
    case 'single'

      hfig = figure;
      h = stairs(x,n);
      title('Histogram plot');
      h = legend(ldv_buildlegend(obj, 'histogram'));
      set(h, 'FontSize', 10)
      set(hfig, 'Name', sprintf('ligoDV plot object: %s', obj.channel));
      xlab = ['Amplitude', ' [',obj.data.unitY,']'];

    case 'stacked'

      h = stairs(x,n);
      title('Histogram plot');
      hold on;
      col = colors{mod(ob-1,Ncols)+1};
      set(h, 'Color', col);
      legendStr = [legendStr ldv_buildlegend(obj, 'histogram')];
      xlab = ['Amplitude', ' [',unit,']'];

    case 'subplots'

      subplot(nobjs, 1, ob)
      h = stairs(x,n);
      hold on;
      h = legend(ldv_buildlegend(obj, 'histogram'));
      set(h, 'FontSize', 10)
      ldv_suptitle('Histogram plot');
      xlab = ['Amplitude', ' [',obj.data.unitY,']'];

    otherwise
      error('### unknown plot configuration');
  end   % end of plot config switch
  
  grid on;
  ylabel('N');
  xlabel(xlab);
  ldv_xaxis(hfig, xlims)
  ldv_yaxis(hfig, ylims)
  
  % add to output data
  dvout.type            = 'Histogram';
  dvout.obj(ob).channel = obj.channel;
  dvout.obj(ob).info    = info;
  dvout.obj(ob).n       = n;
  dvout.obj(ob).x       = x;
  
 
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

end

%% Get outlier fractions from input boxex
% 
function outlier = getOutliers(handles)
  
  lStr = get(handles.plotHistogramLower, 'String');
  uStr = get(handles.plotHistogramUpper, 'String');
  if isempty(lStr)
    outlier.lower = 0.0;
  else
    outlier.lower = str2double(lStr);
  end
  if outlier.lower < 0 | outlier.lower > 1
    error('### lower outlier fraction must be between 0 and 1');
  end
  if isempty(uStr)
    outlier.upper = 0.0;
  else
    outlier.upper = str2double(uStr);
  end
  if outlier.upper < 0 | outlier.upper > 1
    error('### upper outlier fraction must be between 0 and 1');
  end
  if outlier.upper < outlier.lower
    error('### upper outlier fraction must be greater than the lower outlier fraction.');
  end
end





% END
