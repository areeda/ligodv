function ldv_plot_spectrum(handles)

% LDV_PLOT_SPECTRUM Make a spectral plot of the selected data
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
params.scale = ldv_getselectionbox(handles.plotSpectrumScales);
params.win   = ldv_getselectionbox(handles.plotSpectrumWindows);
params.nfft  = str2num(get(handles.plotSpectrumNfft, 'String'));
params.nolap = str2num(get(handles.plotSpectrumNoverlap, 'String'));

% plot configuration
plotcfg = ldv_getselectionbox(handles.plotSpectrumPlots);

% correct for filtering
correctFiltering = get(handles.dv_correctFilters, 'Value');

% mark spectral frequencies?
markFreqs = get(handles.plotSpectrumMarkFreqs, 'Value');

% do noise-floor estimate?
nfon   = get(handles.nfEstChk, 'Value');
nfbw   = str2double(get(handles.nfEstBW, 'String'));
nfol   = str2double(get(handles.nfEstOutliers, 'String'));

% get unit for y-axis
% unit = get(handles.plotUnitTxt, 'String');
unit = ldv_getYunits(handles);

% min/max?
minmax = get(handles.plotSpectrumMinMax, 'Value');

% detect lines?
detectLines = get(handles.plotSpectrumLineDetect, 'Value');

% plot rms?
rmsOn = get(handles.plotSpectrumRMS, 'Value');

% get line detection threshold
lthreshStr = get(handles.plotSpectrumLineThresh, 'String');
if isempty(lthreshStr)
    warning('!!! no line detection threshold given; using default of 1.5.');
    lthresh = 1.5;
else
    lthresh = str2double(lthreshStr);
end

% if we want stacked or subplots, we need a figure now
if strcmp(plotcfg, 'stacked') || strcmp(plotcfg, 'subplots')
    hfig = figure;
    set(hfig, 'Name', ['ligoDV plot objects: ' sprintf('%d, ', dobjs.objs(dobjsidx).id)]);
end

if get(handles.plotSpectrumLogFreq, 'Value')
    log_freq = 1;
else
    log_freq = 0;
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
    obj = dobjs.objs(dobjsidx(ob));

    % prepare data
    [t, x, dinfo] = ldv_preparedata(obj, handles);
    x = x-mean(x);
    
    % set errors for improperly set up FFT
    if params.nfft>length(x)/obj.data.fs
        error('Length of data less than number of seconds per fft.')
    end
    if params.nfft<2/obj.data.fs
        error('Number of seconds per FFT less than twice the inverse of the sample rate.')
    end
    
    % get freqs to mark
    freqs     = getappdata(handles.main, 'freqs');

    % compute spectrum

    if log_freq

        % store user set nfft
        nfft = params.nfft;

        % Averaging
        Kdes = 20;   % desired averages
        Kmin = 10;   % minimum averages

        % Spectral
        Jdes = nfft*obj.data.fs;  % Num spectral frequencies
        olap = 0.5;   % overlap

        % get log frequency vector first
        [lf,r,m, L] = ldv_compute_log_f(obj.data.fs, length(x), Kdes, Kmin, Jdes, olap);

        % first make normal high-res spectrum
        params.nfft  = min([round(10/(lf(2)-lf(1))) length(x)/obj.data.fs]);
        params.scale = 'ASD';
        [f, xx, xxmin, xxmax, info] = ldv_spectrum('MPSD', x, params, obj.data.fs);
        f  = f+dinfo.f0;
        df = f(end)/f(2);
        params.nfft = nfft;
        [f, xx]    = ldv_log_spectrum(f, xx, obj.data.fs, lf);
        [f, xxmin] = ldv_log_spectrum(f, xxmin, obj.data.fs, lf);
        [f, xxmax] = ldv_log_spectrum(f, xxmax, obj.data.fs, lf);

        info.nfft = nfft*obj.data.fs;
        info.enbw = -1;
        info.navs = Kdes;
    else
        [f, xx, xxmin, xxmax, info] = ldv_spectrum('MPSD', x, params, obj.data.fs);
        %[f, xx, info] = dv_spectrum('Welch', x, params, obj.data.fs);
        f  = f+dinfo.f0;
        df = f(end)/f(2);
    end

    % correct for filter responses
    if correctFiltering && obj.filters.apply
        fresp = ldv_getFilterResp(obj, f);
        xx    = xx./abs(fresp);
        xxmin = xxmin./abs(fresp);
        xxmax = xxmax./abs(fresp);
    end

    % detect lines?
    if detectLines || nfon
        %     [lines,nxxmin] = dv_linedetect(f, xxmin, 100, [0 max(f)], lthresh, nfbw, nfol);
        %     [lines,nxxmax] = dv_linedetect(f, xxmax, 100, [0 max(f)], lthresh, nfbw, nfol);
        [lines,nxx]    = ldv_linedetect(f, xx,    100, [0 max(f)], lthresh, nfbw, nfol);

        if detectLines && markFreqs && ~isempty(lines)
            freqs.nfreqs = freqs.nfreqs + length([lines.f]);
            freqs.f      = [freqs.f [lines.f]];
        end

        if detectLines && ~markFreqs && ~isempty(lines)
            freqs.nfreqs = length([lines.f]);
            freqs.f      = [[] lines.f];

        end
    end

    % compute rms?
    if rmsOn
        rmsxx = ldv_spec_rms(f, xx);
        %     f(1)
        %     f(end)
        %     r   = rms([f,xx], 1, length(f));
        %     rmsxx = r(:,2);
        %     rmsf  = r(:,1);
    end

    % object info
    obj.info = structcat(info, dinfo);

    % labels
    xlab = 'Frequency [Hz]';

    % switch through different plot configurations
    switch plotcfg
        case 'single'
            legendStr = [];

            hfig = figure;
            if minmax
                xerr = [xxmin.';[xxmax-xxmin].'].';
                axes; hold on;
                h = area(gca, f, xerr);
                set(h,'LineStyle','none');
                set(h(1),'FaceColor','none');
                set(h(2),'FaceColor', 0.7*[1 1 1]);

                v=get(get(h(2),'Children'),'Vertices');
                v(v==0)=min(xxmin);
                set(get(h(2),'Children'),'Vertices',v);
                set(gca,'YScale','log')

                v=get(get(h(1),'Children'),'Vertices');
                v(v==0)=min(xxmin);
                set(get(h(1),'Children'),'Vertices',v);
                set(gca,'YScale','log')

                legendStr = [legendStr cellstr(' ')];
                legendStr = [legendStr cellstr('\pm\sigma')];
            end
            h = loglog(f, xx);
            set(h(1), 'Color', colors{1});
            hold on;
            title(sprintf('Spectrum plot using %s window', params.win));
            legendStr = [legendStr ldv_buildlegend(obj, 'spectrum')];
            set(hfig, 'Name', sprintf('ligoDV plot object: %s', obj.channel));
            set(gca, 'XScale', 'log', 'XLim', [f(2) max(f)]);
            ylab = spec_ylabel(params.scale, obj.data.unitY);
            % mark frequencies
            if markFreqs || detectLines
                idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(xx));
                h = loglog(f(idx), xx(idx), 'o');
                set(h, 'Color', colors{1}, 'MarkerFaceColor', 'white');
                legendStr = [legendStr cellstr(['Nfreqs=',num2str(length(idx))])];
                disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
                disp([' Frequency(Hz)','     ', 'Amplitude[Counts/rtHz]']); 
                vecF = f(idx)';
                vecXX = xx(idx)';
                disp(sprintf(' %-17i     %i\n',[vecF; vecXX]));
                %         disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
                disp('');
            end

            % noise-floor estimate
            if nfon
                h = loglog(f, nxx);
                set(h, 'Color', colors{1}*0.6);
                legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
            end

            % if rms is on
            if rmsOn
                h = loglog(f, rmsxx);
                set(h, 'Color', colors{1}, 'LineStyle', '--');
                legendStr = [legendStr cellstr(sprintf('rms, dc=%2.3f', rmsxx(1)))];
            end

            % add legend
            h = legend(legendStr);
            set(h, 'FontSize', 10)

        case 'stacked'

            h = loglog(f, xx);
            title(sprintf('Spectrum plot using %s window', params.win));
            hold on; grid on;
            col = colors{mod(ob-1,Ncols)+1};
            set(h, 'Color', col);
            legendStr = [legendStr ldv_buildlegend(obj, 'spectrum')];
            ylab = spec_ylabel(params.scale, unit);
            % mark frequencies
            if markFreqs || detectLines
                idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(xx));
                h = loglog(f(idx), xx(idx), 'o');
                set(h, 'Color', col, 'MarkerFaceColor', 'white');
                legendStr = [legendStr cellstr(['Nfreqs=',num2str(length(idx))])];
                disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
                disp([' Frequency(Hz)','     ', 'Amplitude[Counts/rtHz]']); 
                vecF = f(idx)';
                vecXX = xx(idx)';
                disp(sprintf(' %-17i     %i\n',[vecF; vecXX]));
                
                %                 disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
                disp('');
            end

            % noise-floor estimate
            if nfon
                h = loglog(f, nxx);
                set(h, 'Color', col*0.6);
                legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
            end

            % if rms is on
            if rmsOn
                h = loglog(f, rmsxx);
                set(h, 'Color', col, 'LineStyle', '--');
                legendStr = [legendStr cellstr(sprintf('rms, dc=%2.3f', rmsxx(1)))];
            end

        case 'subplots'

            sp(ob) = subplot(nobjs, 1, ob);
            h = loglog(f, xx);
            set(h, 'Color', colors{1});
            hold on;
            legendStr = ldv_buildlegend(obj, 'spectrum');
            ldv_suptitle(sprintf('Spectrum plot using %s window', params.win));
            ylab = spec_ylabel(params.scale, obj.data.unitY);
            % Mark freqs
            if markFreqs || detectLines
                idx = ldv_getLineIndices(params.nfft, dinfo.f0, freqs.f, f, length(xx));
                h = loglog(f(idx), xx(idx), 'o');
                set(h, 'Color', colors{1}, 'MarkerFaceColor', 'white');
                legendStr = [legendStr cellstr(['Nfreqs=',num2str(length(idx))])];
                disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
                disp([' Frequency(Hz)','     ', 'Amplitude[Counts/rtHz]']); 
                vecF = f(idx)';
                vecXX = xx(idx)';
                disp(sprintf(' %-17i     %i\n',[vecF; vecXX]));
                %                 disp(sprintf('======== %s - %s ===', obj.channel, ldv_gps2utc(dinfo.t0)));
                disp('');
            end

            % noise-floor
            if nfon
                h = loglog(f, nxx);
                set(h, 'Color', colors{1}*0.6);
                legendStr = [legendStr cellstr(sprintf('noise-floor estimate: %2.2f, %2.2f', nfbw, nfol))];
            end

            % if rms is on
            if rmsOn
                h = loglog(f, rmsxx);
                set(h, 'Color', colors{1}, 'LineStyle', '--');
                legendStr = [legendStr cellstr(sprintf('rms, dc=%2.3f', rmsxx(1)))];
            end

            % add legend
            h = legend(legendStr);
            set(h, 'FontSize', 10)
        otherwise
            error('### unknown plot configuration');
    end   % end of plot config switch

    % do we want lin frequency scale
    %if df < 1000
    %  set(gca, 'XScale', 'lin');
    %end
    % add labels and grid
    grid on;
    xlabel(xlab);
    ylabel(ylab);
    ldv_xaxis(hfig, xlims)
    ldv_yaxis(hfig, ylims)

    % add to output data
    dvout.type               = 'Spectrum';
    dvout.obj(ob).channel    = obj.channel;
    dvout.obj(ob).info       = obj.info;
    dvout.obj(ob).info.scale = params.scale;
    dvout.obj(ob).info.unit  = unit;
    dvout.obj(ob).f          = f;
    dvout.obj(ob).xx         = xx;
    if nfon
        dvout.obj(ob).nxx      = nxx;
    end

end  % end of obj loop

% set legend if this is a subplot or stacked
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get ylabel for spectral plot
function ylab = spec_ylabel(scale, unit)

switch scale
    case 'ASD'
        ylab = [sprintf('Amplitude [%s/', unit) '\surdHz]'];
    case 'AS'
        ylab = sprintf('Amplitude [%s]', unit);
    case 'PSD'
        ylab = sprintf('Amplitude [%s^2/Hz]', unit);
    case 'PS'
        ylab = sprintf('Amplitude [%s^2]', unit);
    otherwise
        error('### unknown y scale');
end




