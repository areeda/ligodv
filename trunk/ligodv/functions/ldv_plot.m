function ldv_plot(handles)

% LDV_PLOT main plotting function. Executed when the plot button is pressed,
% this function ultimately produces the plot(s).
%
% M Hewitson 28-07-06
%
% $Id$


% get the selected plot type
plottype = ldv_getselectionbox(handles.plotType);
didx  = ldv_getselecteddobjs(handles);

if ~isempty(didx)
    switch plottype
        case 'Time-series'
            ldv_plot_timeseries(handles);
        case 'Spectrum'
            ldv_plot_spectrum(handles);
        case 'Coherence'
            ldv_plot_coherence(handles);
        case 'TF/CPSD'
            ldv_plot_tf(handles);
        case 'Spectrogram'
            ldv_plot_spectrogram(handles);
        case 'Cross-correlation'
            ldv_plot_xcorr(handles);
        case 'Histogram'
            ldv_plot_histogram(handles);
        case 'XY-scatter'
            ldv_plot_xyscatter(handles);
        case 'Omega Scan'
            ldv_plot_omegagram(handles);
        otherwise
            error('### unknown analysis type');
    end
else
    error('### no data objects selected')
end
end



