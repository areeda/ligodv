function ldv_plot_tf(handles)

% LDV_PLOT_TF Make a transfer function plot of the selected data
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
if nobjs < 2
  error('### please select at least two data objects for a transfer function plot.');
end

% get the primary object
pobj = ldv_getprimaryobject(dobjs, handles.plotTFPrimaryChan);
[pt, px, pinfo] = ldv_preparedata(pobj, handles);
presp           = []; 

% get spectral parameters
params.win   = ldv_getselectionbox(handles.plotTFWindows);
params.nfft  = str2num(get(handles.plotTFNfft, 'String'));
params.nolap = str2num(get(handles.plotTFNoverlap, 'String'));

% plot configuration
plotcfg = ldv_getselectionbox(handles.plotTFPlots);

% correct for filtering
correctFiltering = get(handles.dv_correctFilters, 'Value');

% cross-power or TF?
params.cpsd = get(handles.plotTFcpsd, 'Value');

% mark spectral frequencies?
markFreqs = get(handles.plotSpectrumMarkFreqs, 'Value');
freqs     = getappdata(handles.main, 'freqs');

% compute open loop response?
openloop = get(handles.plotTFOpenLoop, 'Value');

% do noise-floor estimate?
nfon   = get(handles.nfEstChk, 'Value');
nfbw   = str2double(get(handles.nfEstBW, 'String'));
nfol   = str2double(get(handles.nfEstOutliers, 'String'));

% get unit for y-axis
% unit = get(handles.plotUnitTxt, 'String');
unit = ldv_getYunits(handles);
params.unit = unit;

% if we want stacked or subplots, we need a figure now
if strcmp(plotcfg, 'stacked') || strcmp(plotcfg, 'subplots')
  hfig = figure;
  set(hfig, 'Name', ['ligoDV plot objects: ' sprintf('%d, ', dobjs.objs(dobjsidx).id)]);
  
  % setup subplots
  switch plotcfg
    case 'stacked'
      
      msp = subplot(3,1,1:2);
      psp = subplot(3,1,3);
      
    case 'subplots'
      
      n = 1;
      for p=1:nobjs-1        
        msp(p) = subplot(nobjs-1,2, n); n = n + 1;
        psp(p) = subplot(nobjs-1,2, n); n = n + 1;        
      end
      
    otherwise
      error('### unknown plot configuration');
  end
end

% go through each object
legendStr = [];

% get x-limits
xlimStr = get(handles.plotXlims, 'String');
eval(sprintf('xlims = [%s];', xlimStr));
% get y-limits
ylimStr = get(handles.plotYlims, 'String');
eval(sprintf('ylims = [%s];', ylimStr));
% link axes?
link = get(handles.plotLinkChk, 'Value');

% plot title 
ctitle = tfTitle(params, pobj);

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
    
    % set errors for improperly set up FFT
    if params.nfft>length(x)/obj.data.fs
        error('Length of data less than number of seconds per fft.')
    end
    if params.nfft<2/obj.data.fs
        error('Number of seconds per FFT less than twice the inverse of the sample rate.')
    end

    % compute transfer function/ CPSD
    [f, txy, info] = ldv_tf('TFESTIMATE', x, px, params, obj.data.fs, pobj.data.fs);
    df = max(f) - min(f);
    % correct for primary filters
    if correctFiltering && pobj.filters.apply
      if isempty(presp)
        presp = ldv_getFilterResp(pobj, f);
      end
      txy = txy./presp;
    end
    
    % correct for x filters
    if correctFiltering && obj.filters.apply
      fresp = ldv_getFilterResp(obj, f);
      txy = txy.*fresp;
    end
    
    % object info
    obj.info = structcat(info, dinfo);
    
    % compute open-loop?
    if openloop      
      txy = 1./txy -1;
      obj.info.openloop = 1;
    end
    
    % noise-floor estimate?
    if nfon
      nmxx = ldv_nfest(abs(txy), nfbw, nfol);
      npxx = ldv_nfest(ldv_phase(txy), nfbw, nfol);
    end
        
    
    % labels
    xlab  = 'Frequency [Hz]';
    y1lab = tf_ylabel(params, unit, pobj, obj, plotcfg);
    y2lab = 'Phase [deg]';

    % switch through different plot configurations
    switch plotcfg
      case 'single'

        hfig = figure;
        col  = colors{1};
        set(hfig, 'Name', sprintf('ligoDV plot object: %s', obj.channel));
        
        % magnitude
        sp(1) = subplot(3,1,1:2);
        h = loglog(f, abs(txy));
        set(h, 'Color', col);
        hold on;
        ldv_suptitle(ctitle);
        legendStr = ldv_buildlegend(obj, 'coherence');

        if markFreqs
          idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(txy));
          h = loglog(f(idx), abs(txy(idx)), 'o');
          set(h, 'Color', col, 'MarkerFaceColor', 'white');
          legendStr = [legendStr cellstr(' ')];
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp([f(idx) abs(txy(idx)) ldv_phase(txy(idx))])
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp('');
        end
        
        % noise-floor estimate
        if nfon
          h = loglog(f, nmxx);
          set(h, 'Color', colors{1}*0.6);
          legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
        end
        
        % add labels and grid
        grid on; xlabel(''); ylabel(y1lab);

        % add legend
        h = legend(legendStr);
        set(h, 'FontSize', 10)

        % phase subplot
        sp(2) = subplot(3,1,3);
        h = semilogx(f, ldv_phase(txy));
        set(h, 'Color', col);
        hold on;
        
        % mark frequencies
        if markFreqs
          idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(txy));
          h = semilogx(f(idx), ldv_phase(txy(idx)), 'o');
          set(h, 'Color', col, 'MarkerFaceColor', 'white');
        end
        
        % noise-floor estimate
        if nfon
          h = loglog(f, npxx);
          set(h, 'Color', col*0.6);
        end
        
        % add labels and grid
        grid on; xlabel(xlab); ylabel(y2lab);
        
        % link x-axes
        if link
            linkaxes(sp,'x');
        end
        
      case 'stacked'

        % magnitude
        sp(1) = subplot(msp);
        h = loglog(f, abs(txy));
        hold on;
        ldv_suptitle(ctitle);
        col = colors{mod(pn-1,Ncols)+1};
        set(h, 'Color', col);
        legendStr = [legendStr ldv_buildlegend(obj, 'coherence')];
        % mark frequencies
        if markFreqs
          idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(txy));
          h = loglog(f(idx), abs(txy(idx)), 'o');
          set(h, 'Color', col, 'MarkerFaceColor', 'white');
          legendStr = [legendStr cellstr(' ')];
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp([f(idx) abs(txy(idx)) ldv_phase(txy(idx))])
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp('');
        end
        % noise-floor estimate
        if nfon
          h = loglog(f, nmxx);
          set(h, 'Color', col*0.6);
          legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
        end
        % add labels and grid
        grid on; xlabel(''); ylabel(y1lab);

        % phase subplot
        sp(2) = subplot(psp);
        h = semilogx(f, ldv_phase(txy));
        hold on;
        col = colors{mod(pn-1,Ncols)+1};
        set(h, 'Color', col);
        % mark frequencies
        if markFreqs
          h = semilogx(f(idx), ldv_phase(txy(idx)), 'o');
          set(h, 'Color', col, 'MarkerFaceColor', 'white');
        end
        % noise-floor
        if nfon
          h = loglog(f, npxx);
          set(h, 'Color', col*0.6);
        end
        % add labels and grid
        grid on; xlabel(xlab); ylabel(y2lab);
        
        % link x-axes
        if link
            linkaxes(sp,'x');
        end

      case 'subplots'

        % magnitude
        legendStr = [];
        sp(1+ob-1) = subplot(msp(pn));
        h = loglog(f, abs(txy));
        hold on;
        ldv_suptitle(ctitle);
        col = colors{1};
        set(h, 'Color', col);
        legendStr = [legendStr ldv_buildlegend(obj, 'coherence')];
        % mark frequencies
        if markFreqs
          idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, length(txy));
          h = loglog(f(idx), abs(txy(idx)), 'o');
          set(h, 'Color', col, 'MarkerFaceColor', 'white');
          legendStr = [legendStr cellstr(' ')];
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp([f(idx) abs(txy(idx)) ldv_phase(txy(idx))])
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp('');
        end
        % noise-floor
        if nfon
          h = loglog(f, nmxx);
          set(h, 'Color', col*0.6);
          legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
        end
        % add labels and grid
        grid on; xlabel(''); ylabel(y1lab);

        % phase subplot
        sp(2+ob-1) = subplot(psp(pn));
        h = semilogx(f, ldv_phase(txy));
        hold on;
        set(h, 'Color', col);
        % mark frequencies
        if markFreqs
          idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, length(txy));
          h = semilogx(f(idx), ldv_phase(txy(idx)), 'o');
          set(h, 'Color', col, 'MarkerFaceColor', 'white');
        end
        % noise-floor
        if nfon
          h = loglog(f, npxx);
          set(h, 'Color', col*0.6);
        end
        % add labels and grid
        grid on; xlabel(xlab); ylabel(y2lab);
        
        % add legend
        subplot(msp(pn));
        h = legend(legendStr, 'Location', 'NorthOutside');
        set(h, 'FontSize', 10)
        mpos = get(msp(pn), 'Position');
        ppos = get(psp(pn), 'Position');
        ppos(4) = mpos(4);
        set(psp(pn), 'Position', ppos);
        
        
      otherwise
        error('### unknown plot configuration');
    end   % end of plot config switch

    % do we want lin frequency scale
    if df < 1000
%       allxscale('lin');
    end
    ldv_xaxis(hfig, xlims);
    ldv_yaxis(hfig, ylims);
    
    % add to output data
    dvout.type               = sprintf('Transfer function to %s', pobj.channel);
    dvout.obj(pn).channel    = obj.channel;
    dvout.obj(pn).info       = obj.info;
    dvout.obj(pn).f          = f;
    dvout.obj(pn).txy        = txy;
    if nfon
      dvout.obj(pn).nmxx      = nmxx;
      dvout.obj(pn).npxx      = npxx;
    end
    
    % plot counter
    pn = pn + 1;
  end % end of if ~ primary 
end  % end of obj loop

% set legend if this is a subplot or stacked
if strcmp(plotcfg, 'stacked')
  subplot(msp);
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TF title
% 
function str = tfTitle(params, obj)

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
if params.cpsd
  str = [sprintf('Cross-power spectral density plot using %s window\n', params.win)  legendStr];
else
  str = [sprintf('Transfer function plot using %s window\n', params.win)  legendStr];
end
     
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get ylabel for spectral plot
function ylab = tf_ylabel(params, unit, pobj, obj, plotcfg)

  
  if params.cpsd
    ylab = sprintf('Amplitude [%s^2/Hz]', unit);
  else
      if strcmp(plotcfg,'stacked')
          ylab = ['Magnitude', ' [',pobj.data.unitY,'/',unit,']'];
      else
    ylab = ['Magnitude [',pobj.data.unitY,'/',obj.data.unitY,']'];
      end
  end
