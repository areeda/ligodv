function ldv_setplottype(handles)

% LDV_SETPLOTTYPE set the plot type panel that is selected.
%
% M Hewitson 28-07-06
%
% $Id$

% get the selection
plottype = ldv_getselectionbox(handles.plotType);


switch plottype
    case 'Time-series'

        settimeseries(handles, 'on');
        setspectrum(handles,   'off');
        setcoherence(handles,  'off');
        settf(handles,         'off');
        setspectrogram(handles, 'off');
        setnf(handles, 'off');
        setmarkfreqs(handles, 'off');
        seteditfreqs(handles,'on');
        setxcorr(handles, 'off');
        sethist(handles, 'off');
        setXYscatter(handles, 'off');
        setOmegaScan(handles, 'off');
        
        set(handles.plotLinkChk, 'Visible', 'off');

    case 'Spectrum'

        settimeseries(handles, 'off');
        setspectrum(handles,   'on');
        setcoherence(handles,  'off');
        settf(handles,         'off');
        setspectrogram(handles, 'off');
        setnf(handles, 'on');
        setmarkfreqs(handles, 'on');
        seteditfreqs(handles,'on');
        setxcorr(handles, 'off');
        sethist(handles, 'off');
        setXYscatter(handles, 'off');
        setOmegaScan(handles, 'off');
        
        set(handles.plotLinkChk, 'Visible', 'off');

    case 'Coherence'

        settimeseries(handles, 'off');
        setspectrum(handles,   'off');
        setcoherence(handles,  'on');
        settf(handles,         'off');
        setspectrogram(handles, 'off');
        setnf(handles, 'on');
        setmarkfreqs(handles, 'on');
        seteditfreqs(handles,'on');
        setxcorr(handles, 'off');
        sethist(handles, 'off');
        setXYscatter(handles, 'off');
        setOmegaScan(handles, 'off');
        
        set(handles.plotLinkChk, 'Visible', 'off');

    case 'TF/CPSD'

        settimeseries(handles, 'off');
        setspectrum(handles,   'off');
        setcoherence(handles,  'off');
        settf(handles,         'on');
        setspectrogram(handles, 'off');
        setnf(handles, 'on');
        setmarkfreqs(handles, 'on');
        seteditfreqs(handles,'on');
        setxcorr(handles, 'off');
        sethist(handles, 'off');
        setXYscatter(handles, 'off');
        setOmegaScan(handles, 'off');
        
        set(handles.plotLinkChk, 'Visible', 'on');
        set(handles.plotLinkChk, 'Value', 1);

    case 'Spectrogram'

        settimeseries(handles, 'off');
        setspectrum(handles,   'off');
        setcoherence(handles,  'off');
        settf(handles,         'off');
        setspectrogram(handles, 'on');
        setnf(handles, 'on');
        setmarkfreqs(handles, 'off');
        seteditfreqs(handles,'on');
        setxcorr(handles, 'off');
        sethist(handles, 'off');
        setXYscatter(handles, 'off');
        setOmegaScan(handles, 'off');
        
        set(handles.plotLinkChk, 'Visible', 'off');

    case 'Cross-correlation'


        setnf(handles, 'off');
        settimeseries(handles, 'off');
        setspectrum(handles,   'off');
        setcoherence(handles,  'off');
        settf(handles,         'off');
        setspectrogram(handles, 'off');
        setxcorr(handles, 'on');
        sethist(handles, 'off');
        setXYscatter(handles, 'off')
        setmarkfreqs(handles, 'off');
        seteditfreqs(handles,'on');
        setOmegaScan(handles, 'off');
        
        set(handles.plotLinkChk, 'Visible', 'off');

    case 'Histogram'

        setnf(handles, 'off');
        settimeseries(handles, 'off');
        setspectrum(handles,   'off');
        setcoherence(handles,  'off');
        settf(handles,         'off');
        setspectrogram(handles, 'off');
        setxcorr(handles, 'off');
        sethist(handles, 'on');
        setXYscatter(handles, 'off')
        setmarkfreqs(handles, 'off');
        seteditfreqs(handles,'on');
        setOmegaScan(handles, 'off');
        
        set(handles.plotLinkChk, 'Visible', 'off');

    case 'XY-scatter'

        setnf(handles, 'off');
        settimeseries(handles, 'off');
        setspectrum(handles,   'off');
        setcoherence(handles,  'off');
        settf(handles,         'off');
        setspectrogram(handles, 'off');
        setxcorr(handles, 'off');
        sethist(handles, 'off');
        setXYscatter(handles, 'on')
        setmarkfreqs(handles, 'off');
        seteditfreqs(handles,'on');
        setOmegaScan(handles, 'off');
        
        set(handles.plotLinkChk, 'Visible', 'off');
        
    case 'Omega Scan'

        setnf(handles, 'off');
        settimeseries(handles, 'off');
        setspectrum(handles,   'off');
        setcoherence(handles,  'off');
        settf(handles,         'off');
        setspectrogram(handles, 'off');
        setxcorr(handles, 'off');
        sethist(handles, 'off');
        setXYscatter(handles, 'off')
        setmarkfreqs(handles, 'off');
        seteditfreqs(handles,'on');
        setOmegaScan(handles, 'on');
        
        set(handles.plotLinkChk, 'Visible', 'off');

    otherwise
        error('### unknown analysis type');
end

end



%% Set the noisefloor estimate boxes on or off
%
function setnf(handles, state)

set(handles.nfEstBW, 'Enable', state);
set(handles.nfEstOutliers, 'Enable', state);
set(handles.nfEstChk, 'Enable', state);

end

%% Set the mark freqs box on or off
%
function setmarkfreqs(handles, state)

set(handles.plotSpectrumMarkFreqs, 'Enable', state);

end

%% Set the edit freqs boxes on or off
%
function seteditfreqs(handles, state)

set(handles.dv_spectrumEditFreqs, 'Enable', state);
set(handles.plotSpectrumNfreqs, 'Enable', state);

end


%% lpsd panel
%
function setlpsd(handles, state)

% set panel state
set(handles.plotLPSDPanel, 'Visible', state);

% set plot configuration
set(handles.plotLPSDPlots, 'String', {'single', 'stacked'});
set(handles.plotLPSDPlots, 'Value', 2);

end




%% Histogram panel
%
function sethist(handles, state)

% set panel state
set(handles.plotHistogramPanel, 'Visible', state);

% set plot configuration
set(handles.plotHistogramPlots, 'String', {'single', 'stacked', 'subplots'});
set(handles.plotHistogramPlots, 'Value', 2);

end




%% Cross-correlation panel
%
function setxcorr(handles, state)

% set panel state
set(handles.plotXCorrPanel, 'Visible', state);

% set plot configuration
set(handles.plotXCorrPlots, 'String', {'single', 'stacked', 'subplots'});
set(handles.plotXCorrPlots, 'Value', 2);

% set scale options
set(handles.plotXCorrScaleopts, 'String', {'biased', 'unbiased', 'coeff', 'none'});
set(handles.plotXCorrScaleopts, 'Value', 2);

end
%% Time-series panel
%
function settimeseries(handles, state)

% set panel state
set(handles.plotTimeSeriesPanel, 'Visible', state);

% set plot configuration
set(handles.plotTimeSeriesPlots, 'String', {'single', 'stacked', 'subplots'});
set(handles.plotTimeSeriesPlots, 'Value', 2);

% set math examples
set(handles.plotTimeSeriesMathEGs, 'String',...
    {'u', 'u-mean(u)',...
    'u.^2', '2*u',});
set(handles.plotTimeSeriesMathEGs, 'Value', 1);

end

%% Spectrum panel
%
function setspectrum(handles, state)

settings = getappdata(handles.main, 'settings');

% set panel state
set(handles.plotSpectrumPanel, 'Visible', state);

% set plot configuration
set(handles.plotSpectrumPlots, 'String', {'single', 'stacked', 'subplots'});
set(handles.plotSpectrumPlots, 'Value', 2);

% set plot scales
set(handles.plotSpectrumScales, 'String', {'ASD', 'AS', 'PSD', 'PS'});
set(handles.plotSpectrumScales, 'Value', 1);

% set windows
set(handles.plotSpectrumWindows, 'String', settings.windows);
set(handles.plotSpectrumWindows, 'Value', 2);

% set nfft and overlap
nfftstr  = get(handles.plotSpectrumNfft, 'String');
nolapstr = get(handles.plotSpectrumNoverlap, 'String');
if isempty(nfftstr) || str2num(nfftstr)==0
    set(handles.plotSpectrumNfft, 'String', '1');
end
if isempty(nolapstr) || str2num(nolapstr)==0
    set(handles.plotSpectrumNoverlap, 'String', '0.5');
end

end


%% Coherence panel
%
function setcoherence(handles, state)

settings = getappdata(handles.main, 'settings');

% set panel state
set(handles.plotCoherencePanel, 'Visible', state);

% set plot configuration
set(handles.plotCoherencePlots, 'String', {'single', 'stacked', 'subplots'});
set(handles.plotCoherencePlots, 'Value', 2);

% primary channel set by dobj list calllback

% set windows
set(handles.plotCoherenceWindows, 'String', settings.windows);
set(handles.plotCoherenceWindows, 'Value', 2);


% set nfft and overlap
nfftstr  = get(handles.plotCoherenceNfft, 'String');
nolapstr = get(handles.plotCoherenceNoverlap, 'String');
if isempty(nfftstr) || str2num(nfftstr)==0
    set(handles.plotCoherenceNfft, 'String', '1');
end
if isempty(nolapstr) || str2num(nolapstr)==0
    set(handles.plotCoherenceNoverlap, 'String', '0.5');
end

end

%% XYscatter panel
%
function setXYscatter(handles, state)

settings = getappdata(handles.main, 'settings');

% set panel state
set(handles.plotXYscatterPanel, 'Visible', state);

% set plot configuration
set(handles.plotXYscatterPlots, 'String', {'single', 'stacked', 'subplots'});
set(handles.plotXYscatterPlots, 'Value', 2);

% primary channel set by dobj list calllback

end

%% TF panel
%
function settf(handles, state)

settings = getappdata(handles.main, 'settings');

% set panel state
set(handles.plotTFPanel, 'Visible', state);

% set plot configuration
set(handles.plotTFPlots, 'String', {'single', 'stacked', 'subplots'});
set(handles.plotTFPlots, 'Value', 2);

% primary channel set by dobj list calllback

% set windows
set(handles.plotTFWindows, 'String', settings.windows);
set(handles.plotTFWindows, 'Value', 2);


% set nfft and overlap
nfftstr  = get(handles.plotTFNfft, 'String');
nolapstr = get(handles.plotTFNoverlap, 'String');
if isempty(nfftstr) || str2num(nfftstr)==0
    set(handles.plotTFNfft, 'String', '1');
end
if isempty(nolapstr) || str2num(nolapstr)==0
    set(handles.plotTFNoverlap, 'String', '0.5');
end

end


%% Spectrogram panel
%
function setspectrogram(handles, state)

settings = getappdata(handles.main, 'settings');

% set panel state
set(handles.plotSpectrogramPanel, 'Visible', state);

% set plot configuration
set(handles.plotSpectrogramPlots, 'String', {'single', 'subplots'});
set(handles.plotSpectrogramPlots, 'Value', 1);

% set windows
set(handles.plotSpectrogramWindows, 'String', settings.windows);
set(handles.plotSpectrogramWindows, 'Value', 2);

% set nfft and overlap
nfftstr  = get(handles.plotSpectrogramNfft, 'String');
nolapstr = get(handles.plotSpectrogramNoverlap, 'String');
if isempty(nfftstr) || str2num(nfftstr)==0
    set(handles.plotSpectrogramNfft, 'String', '1');
end
if isempty(nolapstr) || str2num(nolapstr)==0
    set(handles.plotSpectrogramNoverlap, 'String', '0.5');
end

% set colormaps
set(handles.plotSpectrogramColorMap, 'String', settings.colormaps);
set(handles.plotSpectrogramColorMap, 'Value', 1);


end

%% Bicoherence panel
%
function setbicohere(handles, state)

settings = getappdata(handles.main, 'settings');

% set panel state
set(handles.plotBicoherePanel, 'Visible', state);

% set plot configuration
set(handles.plotBicoherePlots, 'String', {'single', 'subplots'});
set(handles.plotBicoherePlots, 'Value', 1);

% set windows
set(handles.plotBicohereWindows, 'String', settings.windows);
set(handles.plotBicohereWindows, 'Value', 1);

% set nfft and overlap
nfftstr  = get(handles.plotBicohereNfft, 'String');
nfstr    = get(handles.plotBicohereNf, 'String');
if isempty(nfftstr) || str2num(nfftstr)==0
    set(handles.plotBicohereNfft, 'String', '1');
end
if isempty(nfstr) || str2num(nfstr)==0
    set(handles.plotBicohereNoverlap, 'String', '100');
end

% set colormaps
set(handles.plotBicohereColorMap, 'String', settings.colormaps);
set(handles.plotBicohereColorMap, 'Value', 4);


end

%% Omegagram panel
%
function setOmegaScan(handles, state)

  settings = getappdata(handles.main, 'settings');
  
  % set panel state  
  set(handles.plotOmegaScanPanel, 'Visible', state);

  
  % set nfft and overlap
  FARstr = get(handles.plotOmegagramFAR, 'String');  
  if isempty(FARstr) 
    set(handles.plotOmegagramFAR, 'String', '0');
  end
    
  % set colormaps
  set(handles.plotOmegagramColorMap, 'String', settings.colormaps);
  set(handles.plotOmegagramColorMap, 'Value', 1);
  
  % set normalization style
  set(handles.plotOmegagramNormMenu, 'String', {'none','flat','reference'});
  set(handles.plotOmegagramNormMenu, 'Value',2);
  
end

% END
