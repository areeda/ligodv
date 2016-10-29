function ldv_plot_spectrogram(handles)

% LDV_PLOT_SPECTROGRAM Make a spectrogram plot of the selected data
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

% get spectral parameters
% params.scale = dv_getselectionbox(handles.plotSpectrogramScales);
params.win   = ldv_getselectionbox(handles.plotSpectrogramWindows);
params.nfft  = str2num(get(handles.plotSpectrogramNfft, 'String'));
params.nolap = str2num(get(handles.plotSpectrogramNoverlap, 'String'));

% plot configuration
plotcfg = ldv_getselectionbox(handles.plotSpectrogramPlots);

% correct for filtering
correctFiltering = get(handles.dv_correctFilters, 'Value');

% do pixel interpolation?
interp = get(handles.plotSpectrogramInterpolate, 'Value');

% normalise?
normalise = get(handles.plotSpectrogramNormalise, 'Value');

% log y-axis?
logy = get(handles.plotSpectrogramLogY, 'Value');

% colormap
cmap = ldv_getselectionbox(handles.plotSpectrogramColorMap);

% sig pix?
edgedetect       = get(handles.plotSpectrogramEdges, 'Value');

% do noise-floor estimate?
nfon   = get(handles.nfEstChk, 'Value');
nfbw   = str2double(get(handles.nfEstBW, 'String'));
nfol   = str2double(get(handles.nfEstOutliers, 'String'));

% get unit for y-axis
% unit = get(handles.plotUnitTxt, 'String');
unit = ldv_getYunits(handles);

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
% link axes?
link = get(handles.plotLinkChk, 'Value');

% data store
dvout = [];

% go through each object
legendStr = [];
for ob = 1:nobjs

  % get current object
  obj  = dobjs.objs(dobjsidx(ob));
  
  % prepare data
  [t, x, dinfo] = ldv_preparedata(obj, handles);
  
  % set errors for improperly set up FFT
  if params.nfft>length(x)/obj.data.fs
      error('Length of data less than number of seconds per fft.')
  end
  if params.nfft<2/obj.data.fs
      error('Number of seconds per FFT less than twice the inverse of the sample rate.')
  end
  
  % compute spectrogram
  [t, f, sxx, info] = ldv_spectrogram('Matlab', x, params, obj.data.fs);
  f = f+dinfo.f0;
    
  % correct for filter responses
  if correctFiltering && obj.filters.apply
    fresp = diag(abs(ldv_getFilterResp(obj, f)));
    sxx = [transpose(sxx)/fresp].';
  end
  
  % noise floor?
  if nfon
      sxx = ldv_sxx2nfest(sxx, nfbw, nfol);
  end

  % normalise?
  if normalise
      [sxx, mu, sig]    = ldv_normalise_spectrogram(f, sxx);
      cbtstr = 'Normalised amplitude';
      if nfon
          cbtstr = 'Normalised NF amplitude';
      end
  else
      sxx    = log10(sxx);
      cbtstr = [sprintf('Log_{10}(Amplitude [%s/', obj.data.unitY) '\surdHz])'];
      if nfon
          cbtstr = [sprintf('Log_{10}(NF amplitude [%s/', obj.data.unitY) '\surdHz])'];
      end
  end
  
  if edgedetect
%     sxx = randn(size(sxx));
    [sxx, or] = ldv_canny(sxx, 1);
%     sxx = fastradial(sxx, [ 3 5 7], 2);
%     sxx = harris(sxx, 2);
%     sxx = or;
  end
  

  
  % object info
  obj.info = structcat(info, dinfo);
  tstr     = specgram_title(obj);

  % labels 
  xlab = 'Time [s]';
  ylab = 'Frequency [Hz]';
  
  % switch through different plot configurations
  switch plotcfg
    case 'single'

      hfig = figure;
      h = pcolor(t, f, sxx);
      hold on;
      title(tstr);
      set(hfig, 'Name', sprintf('ligoDV plot object: %s', obj.channel));

    case 'subplots'

      sp(ob) = subplot(nobjs, 1, ob);
      h = pcolor(t, f, sxx);
      hold on; 
      legendStr = ldv_buildlegend(obj, 'spectrum');
      title(tstr);
      
    otherwise
      error('### unknown plot configuration');
  end   % end of plot config switch

  
  % plot settings
  hc = colorbar;
  set(get(hc, 'Label'), 'String', cbtstr, 'Fontweight', 'bold', 'VerticalAlignment', 'top');
  colormap(cmap);
  if interp
    set(h, 'EdgeColor', 'interp', 'FaceColor', 'interp', 'FaceLighting','phong');
  else
    set(h, 'EdgeColor', 'none', 'FaceLighting','phong');
  end
  set(gca, 'YDir');
  grid on;
  set(gca, 'Layer', 'top');
  
  % log y-axis
  if logy
    set(gca, 'Yscale', 'log');
  end
  
  % add labels and grid
  grid on;
  xlabel(xlab);
  ylabel(ylab);
  ldv_xaxis(hfig, xlims)
  ldv_yaxis(hfig, ylims)

  
  % add to output data
  dvout.type               = 'Spectrogram';
  dvout.obj(ob).channel    = obj.channel;
  dvout.obj(ob).info       = obj.info;
  dvout.obj(ob).info.unit  = unit;
  dvout.obj(ob).t          = t;
  dvout.obj(ob).f          = f;
  dvout.obj(ob).sxx        = sxx;
  
end  % end of obj loop

% save output data
if get(handles.plotSaveChk, 'Value')  
  ldv_dataProductSave(dvout)
end

% link x-axes for subplots
if strcmp(plotcfg, 'subplots')
    if link
        linkaxes(sp,'x');
    end
end

% export output data
if get(handles.plotExportChk, 'Value')  
  ldv_dataProductExport(dvout)
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get title for spectrogram plot
function tstr = specgram_title(obj)

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

% build title    
tstr =  [...
              sprintf('Spectrogram of %02d:%s\n', obj.id, ldv_chan2label(obj.channel))...
              sprintf('fs = %d : %ds from %s - %s\n',...
                  obj.data.fs, nsecs, ldv_gps2utc(startgps), obj.comment)...
              sprintf('nfft=%d, nolap=%2.2f, enbw=%2.2g',...
                      obj.info.nfft, obj.info.nolap, obj.info.enbw)...
          ];

if obj.preproc.heterodyneOn
  tstr = [tstr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
end

