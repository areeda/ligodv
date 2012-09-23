function ldv_plot_coherence(handles)

% LDV_PLOT_COHERENCE Make a coherence plot of the selected data
% objects.
% 
% M Hewitson
% 
% $Id$
% 
% 

% settings
settings = getappdata(handles.main, 'settings');
colors   = settings.general.colors;
Ncols    = length(colors);

% get the selected data objects
dobjsidx = ldv_getselecteddobjs(handles);
dobjs    = getappdata(handles.main, 'dobjs');
nobjs    = length(dobjsidx);

% check what is selected
if nobjs < 2
  error('### please select at least two data objects for a coherence plot.');
end

% get the primary object
pobj = ldv_getprimaryobject(dobjs, handles.plotCoherencePrimaryChan);
[pt, px, pinfo] = ldv_preparedata(pobj, handles);

% get spectral parameters
params.win   = ldv_getselectionbox(handles.plotCoherenceWindows);
params.nfft  = str2num(get(handles.plotCoherenceNfft, 'String'));
params.nolap = str2num(get(handles.plotCoherenceNoverlap, 'String'));

% plot configuration
plotcfg = ldv_getselectionbox(handles.plotCoherencePlots);

% do noise-floor estimate?
nfon   = get(handles.nfEstChk, 'Value');
nfbw   = str2double(get(handles.nfEstBW, 'String'));
nfol   = str2double(get(handles.nfEstOutliers, 'String'));

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
ctitle = cohereTitle(params, pobj);

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
    [f, cxy, info] = ldv_coherence('MSCOHERE', x, px, params, obj.data.fs, pobj.data.fs);
    df = max(f)-min(f);
    
    if nfon
      nxx = ldv_nfest(cxy, nfbw, nfol);
    end
    
    % object info
    obj.info = structcat(info, dinfo);

    % labels
    xlab = 'Frequency [Hz]';
    ylab = 'Coherence';

    % switch through different plot configurations
    switch plotcfg
      case 'single'

        hfig = figure;
        h = semilogx(f, cxy);
        set(h, 'Color', colors{1});
        hold on;
        title(ctitle);
        legendStr = ldv_buildlegend(obj, 'coherence');
        set(hfig, 'Name', sprintf('ligoDV plot object: %s', obj.channel));

        if markFreqs
          idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(cxy));
          h = semilogx(f(idx), cxy(idx), 'o');
          set(h, 'Color', colors{1}, 'MarkerFaceColor', 'white');
          legendStr = [legendStr cellstr(' ')];
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp([f(idx) cxy(idx)])
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp('');
        end

        % noise-floor estimate
        if nfon
          h = semilogx(f, nxx);
          set(h, 'Color', colors{1}*0.6);
          legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
        end
      
        % add legend
        legend(legendStr);

      case 'stacked'

        h = semilogx(f, cxy);
        title(ctitle);
        hold on; grid on;
        col = colors{mod(pn-1,Ncols)+1};
        set(h, 'Color', col);
        legendStr = [legendStr ldv_buildlegend(obj, 'coherence')];

        if markFreqs
          idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(cxy));
          h = semilogx(f(idx), cxy(idx), 'o');
          set(h, 'Color', col, 'MarkerFaceColor', 'white');
          legendStr = [legendStr cellstr(' ')];
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp([f(idx) cxy(idx)])
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp('');
        end

        % noise-floor estimate
        if nfon
          h = semilogx(f, nxx);
          set(h, 'Color', col*0.6);
          legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
        end

      case 'subplots'

        sp(ob) = subplot(nobjs-1, 1, pn);
        h = semilogx(f, cxy);
        set(h, 'Color', colors{1});
        hold on;
        legendStr = ldv_buildlegend(obj, 'coherence');
        
        ldv_suptitle(ctitle);
        if markFreqs
          idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(cxy));
          h = semilogx(f(idx), cxy(idx), 'o');
          set(h, 'Color', colors{1}, 'MarkerFaceColor', 'white');
          legendStr = [legendStr cellstr(' ')];
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp([f(idx) cxy(idx)])
          disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
          disp('');
        end

        % noise-floor
        if nfon
          h = semilogx(f, nxx);
          set(h, 'Color', colors{1}*0.6);
          legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
        end

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
    % do we want lin frequency scale
%     if df < 1000
%       set(gca, 'XScale', 'lin');
%     end
    ldv_xaxis(hfig, xlims)
    ldv_yaxis(hfig, ylims)
    
    % add to output data
    dvout.type               = sprintf('Coherence with %s', pobj.channel);
    dvout.obj(pn).channel    = obj.channel;
    dvout.obj(pn).info       = obj.info;
    dvout.obj(pn).f          = f;
    dvout.obj(pn).cxy        = cxy;
    if nfon
      dvout.obj(pn).nxx      = nxx;
    end
    
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
% Coherence title
% 
function str = cohereTitle(params, obj)

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
str = [sprintf('Coherence plot using %s window\n', params.win)  legendStr];

     
     
     
