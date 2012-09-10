function ldv_settooltips(handles)

% LDV_SETTOOLTIPS set all tooltips for each gui element.
% 
% M Hewitson 28-07-06
% 
% $Id$
% 

%% Mode select panel

% dataviewer mode selection
tip = sprintf('Select data server type, either NDS or LDR.');
set(handles.dvmode, 'TooltipString', tip);

%% Mode Panel

%-- LIGO NDS Mode

% data type selection
tip = sprintf('Select the data type to get.');
set(handles.gd_dataTypeSelect, 'TooltipString', tip);

% server default list
tip = sprintf('Select from one of the default servers.');
set(handles.gd_serverSelect, 'TooltipString', tip);

% server text entry
tip = sprintf('Enter the internet name of a data server.');
set(handles.gd_serverInputTxt, 'TooltipString', tip);

% port entry
tip = sprintf('Enter the port for the data server.');
set(handles.gd_portInputTxt, 'TooltipString', tip);

% rds level
tip = sprintf('Enter the RDS level\nif you are getting h(t) frames.');
set(handles.gd_rdslevel, 'TooltipString', tip);

% cal version
tip = sprintf('Enter the calibration version\nif you are getting h(t) frames.');
set(handles.gd_calversion, 'TooltipString', tip);

% statistic
tip = sprintf('Select the statistic for trend data.');
set(handles.gd_stat, 'TooltipString', tip);

% query server
tip = sprintf('Get a list of channels from the server.');
set(handles.gd_queryServerBtn, 'TooltipString', tip);

% LIGO LDR Server



%% Time Settings Panel

% input mode
tip = sprintf('Choose between UTC and GPS input modes.');
set(handles.timeInputMode, 'TooltipString', tip);

% get latest time
tip = sprintf('Retrieve current time from system clock, convert to UTC and GPS.');
%set(handles.getLatestBtn, 'TooltipString', tip);

% UTC start input
tip = [sprintf('Input the start time in UTC format\n')...
       sprintf('"yyyy-mm-dd HH:MM:SS", e.g. 2006-05-04 11:23:56.\n')...
       sprintf('You can also enter "- Nsecs" relative to the stop time,\n')...
       sprintf('e.g. entering "-60*5" will set the start time five minutes\n')...
       sprintf('earlier than the stop time.\n')...
       sprintf('The input will round to integer seconds.')];
set(handles.utcStartInput, 'TooltipString', tip);

% UTC stop input
tip = [sprintf('Input the stop time in UTC format\n')...
       sprintf('"yyyy-mm-dd HH:MM:SS", e.g. 2006-05-04 11:23:56.\n')...
       sprintf('You can also enter "+ Nsecs" relative to the start time,\n')...
       sprintf('e.g. entering "+60*5" will set the stop time five minutes\n')...
       sprintf('later than the start time.\n')...
       sprintf('The input will round to integer seconds.')];
set(handles.utcStopInput, 'TooltipString', tip);

% GPS start input
tip = [sprintf('Input the start time in GPS format,\n e.g. 799876543.\n')...
       sprintf('The input will round to integer seconds.')];
set(handles.gpsStartInput, 'TooltipString', tip);

% GPS stop input
tip = [sprintf('Input the stop time in GPS format,\n e.g. 799876543.\n')...
       sprintf('The input will round to integer seconds.')];
set(handles.gpsStopInput, 'TooltipString', tip);

% set start latest
tip = sprintf('Set the start time to be the current time set above minus one second.');
set(handles.startSetLatestBtn, 'TooltipString', tip);

% set stop latest
tip = sprintf('Set the stop time to be the current time set above.');
set(handles.stopSetLatestBtn, 'TooltipString', tip);

% single time select
tip = sprintf('Choose single time mode.\nGet data for only a single time.');
set(handles.singleTimeRB, 'TooltipString', tip);

% time list select
tip = sprintf('Choose time list mode.\nGet data for multiple times.');
set(handles.timeListRB, 'TooltipString', tip);

% edit times btn
tip = sprintf('Open a dialog box to edit a list of times.');
set(handles.editTimesBtn, 'TooltipString', tip);

% comment field
tip = sprintf('Enter a comment to be associated\nwith the single time entered.\ne.g. windy time.');
set(handles.commentInput, 'TooltipString', tip);



%% Channel List Panel

% get channel list
tip = sprintf('Get a channel list from the selected server.');
set(handles.getChannelListBtn, 'TooltipString', tip);

% channel list
tip = sprintf('Displays channel name and sample rate in Hz.\n Select the channels you wish to get data for.');
set(handles.channelList, 'TooltipString', tip);

% with control channels
tip = sprintf('Include channels sampled at less than 256Hz in the list.');
set(handles.includeControlChansChk, 'TooltipString', tip);

% search box
tip = sprintf('Search for channels containing a particular string.\n This uses AND functionality and is not case sensitive.');
set(handles.channelSearchTxt, 'TooltipString', tip);

% reload channel list
tip = sprintf('Recall full channel list from memory.');
set(handles.reloadChannelList, 'TooltipString', tip);

%% Pre-processing Panel

% unit selection
tip = sprintf('Select which unit to display the data in \n(i.e. choose to apply ADC signal slope or not).');
set(handles.preprocUnits, 'TooltipString', tip);

% resample selection
tip = sprintf('Resample data by the given factor before storing.\nThis allows for longer data stretches\nto be retrieved.');
set(handles.preprocResampleR, 'TooltipString', tip);

% math input
tip = sprintf(['Input a math formula here as a function of u.\n'...
               'The input formula will be applied to the data before storing.\n'...
               'For example, entering u.^2 will square all data samples\n for each channel before storing.'...
               ]);
set(handles.preprocMathInput, 'TooltipString', tip);

% whitening
tip = sprintf('Whiten the data. Experimental.');
set(handles.preprocWhitening, 'TooltipString', tip);

% heterodyne 
tip = sprintf('Heterodyne the data using the f0 specified below.');
set(handles.preprocHet, 'TooltipString', tip);

% heterodyne f0
tip = sprintf('Set the f0 for heterodyning.');
set(handles.preprocF0, 'TooltipString', tip);


%% Data Pool Panel

% get data btn
tip = sprintf('Retrieve the selected channels for the selected time(s)\nfrom the selected source.');
set(handles.getDataBtn, 'TooltipString', tip);

% object list
tip = sprintf('Click on a data object to see the details.');
set(handles.dataObjects, 'TooltipString', tip);

% delete selected btn
tip = sprintf('Delete selected data objects from the list.');
set(handles.deleteSelectedDobjsBtn, 'TooltipString', tip);

% clear all btn
tip = sprintf('Delete all data objects from the list.');
set(handles.clearAllDobjsBtn, 'TooltipString', tip);

% set filters btn
tip = sprintf([...
               'Opens a dialog for filter design. The final filter list will\n'...
                'be applied to all selected data objects.'...
                ]);
set(handles.dobjsSetFiltersBtn, 'TooltipString', tip);

% clear filters btn
tip = sprintf('Clear all filters from the selected data objects.');
set(handles.dobjClearFilters, 'TooltipString', tip);

% save object btn
tip = sprintf('Save selected object(s) to a .mat file.');
set(handles.saveObjectsBtn, 'TooltipString', tip);

% load object btn
tip = sprintf('Load object(s) from a .mat file.');
set(handles.loadObjectsBtn, 'TooltipString', tip);

% export objects btn
tip = sprintf('Export selected object(s) as a workspace variable.');
set(handles.exportObjectsBtn, 'TooltipString', tip);

% duplicate objects btn
tip = sprintf('Duplicate selected object(s).');
set(handles.duplicateObjectsBtn, 'TooltipString', tip);

% data object info text box
tip = sprintf('Right-click (control click on MAC) \nto print into the MATLAB Command Window');
set(handles.dobjInfoTxt, 'TooltipString', tip);

% launch SPtool 
tip = sprintf('Open the Matlab Signal Processing Tool \nand load the selected data object.');
set(handles.launchSPtool, 'TooltipString', tip);

% combine objects math 
tip = sprintf(['Input a math formula here that is a function of\n',...
    'selected objects xN, where N is the object ID shown in the\n',...
    'left column of the Data pool.']);
set(handles.combineObjsMathTxt, 'TooltipString', tip);

% combine objects button
tip = sprintf('Combine selected objects into a new object using the above formula.');
set(handles.combineObjsBtn, 'TooltipString', tip);

% edit filters 
tip = sprintf('Edit the filters for the selected data object.');
set(handles.dobjInfoEditFiltersBtn, 'TooltipString', tip);

% include prime check
tip = sprintf(['Include some data prior to the selected times to allow\n'...
               'for filter transients. The extra data is removed after\n'...
               'filtering and before plotting.']);
set(handles.dv_getPrimeData, 'TooltipString', tip);

% search box
tip = sprintf(['Enter a search string to reduce the number of displayed\n'...
               'data objects. Leave box empty to see the full list of\n'...
               'data objects.']);
set(handles.dobjsSearchTxt, 'TooltipString', tip);


% apply filters on/off
tip = sprintf('Toggle the apply-filters state for the selected data objects.');
set(handles.dv_applyFiltersOn, 'TooltipString', tip);
set(handles.dv_applyFiltersOff, 'TooltipString', tip);




%% Analysis Panel

% analysis selector
tip = sprintf('Choose the type of analysis to do.');
set(handles.plotType, 'TooltipString', tip);

% plot data select
tip = sprintf(['Select the time range of data to include in the analysis, in seconds.\n'...
    'Default is the full data set. Entering, e.g., 3:end will include data from  \n'... 
    'second three to the end of the selected data segement(s).']);
set(handles.plotDataSelect, 'TooltipString', tip);

% noise floor bw
tip = sprintf('Specify bandwidth [Hz] to use in noise-floor estimate.');
set(handles.nfEstBW, 'TooltipString', tip);

% noise floor outlier
tip = sprintf(['Specify fraction of data [0-1] in each BW to use in median determination\n'... 
    'for noise-floor estimate. eg, 0.9 throws away highest 0.1 of data in BW.']);
set(handles.nfEstOutliers, 'TooltipString', tip);

% noise floor estimate
tip = sprintf('Plot a noise floor estimate using the parameters below.');
set(handles.nfEstChk, 'TooltipString', tip);

% correct filters
tip = sprintf(['Correct for the response of any filters applied. The\n'...
               'correction is done in the frequency domain.']);
set(handles.dv_correctFilters, 'TooltipString', tip);

% mark freqs
tip = sprintf(['Put markers on the data points with frequency values nearest to those specified\n'...
    'in the frequencies list. Display freq and value in command window.']);
set(handles.plotSpectrumMarkFreqs, 'TooltipString', tip);

% edit frequencies
tip = sprintf('Open a dialog box to edit the list of frequencies for marking.');
set(handles.dv_spectrumEditFreqs, 'TooltipString', tip);

% units
% tip = sprintf('Select the units to appear on the y-axis of plots.');
% set(handles.plotUnitTxt, 'TooltipString', tip);
% set(handles.plotUnitSelect, 'TooltipString', tip);

% save products
tip = sprintf('Save the plotted output products to a .mat file.');
set(handles.plotSaveChk, 'TooltipString', tip);

% export products
tip = sprintf('Export the plotted output products as a workspace variable.');
set(handles.plotExportChk, 'TooltipString', tip);

% X limits
tip = sprintf('Specify the x-axis limits for the plot display, e.g. 10,30');
set(handles.plotXlims, 'TooltipString', tip);

% Y limits
tip = sprintf('Specify the y-axis limits for the plot display, e.g. -5,5');
set(handles.plotYlims, 'TooltipString', tip);

% plot
tip = sprintf('Produce the selected plots.');
set(handles.plotPlotBtn, 'TooltipString', tip);

%---------------------- Time series

% plot configuration
tip = sprintf('Choose the plot layout configuration.');
set(handles.plotTimeSeriesPlots, 'TooltipString', tip);

% math input 
tip = sprintf(['Input a math formula here as a function of u.\n'...
               'The input formula will be applied to the data before\n'...
               'any filtering and plotting. For example, entering \n'...
               'u.^2 will square all data samples for each channel.'...
               ]);
set(handles.plotTimeSeriesMathTxt, 'TooltipString', tip);

% math examples
tip = sprintf(['Choose an example math formula.\n'...
               'The input formula will be applied to the data before\n'...
               'any filtering and plotting. For example, entering \n'...
               'u.^2 will square all data samples for each channel.'...
               ]);           
set(handles.plotTimeSeriesMathEGs, 'TooltipString', tip);



%---------------------- Spectrum

% plot config
tip = sprintf('Choose the plot layout configuration.');
set(handles.plotSpectrumPlots, 'TooltipString', tip);

% scaling
tip = sprintf('Choose the spectrum scaling.');
set(handles.plotSpectrumScales, 'TooltipString', tip);

% window function
tip = sprintf('Choose the window function to apply to the data before Fourier transforming.');
set(handles.plotSpectrumWindows, 'TooltipString', tip);

% Nfft
tip = sprintf(['Enter the number of seconds of data to use for each fft.']);
set(handles.plotSpectrumNfft, 'TooltipString', tip);

% Noverlap
tip = sprintf('Enter the overlap fraction for subsequent segments (0-1).');
set(handles.plotSpectrumNoverlap, 'TooltipString', tip);

% RMS
tip = sprintf(['Plot cumulative contribution of spectral bins to the RMS\n'... 
    'from high frequency to low.']);
set(handles.plotSpectrumRMS, 'TooltipString', tip);

% +/- Sig
tip = sprintf('Plot +/- one standard deviation envelope for data.');
set(handles.plotSpectrumMinMax, 'TooltipString', tip);

% log freq
tip = sprintf('Plot spectrum with a logarithmic frequency vector (slow).');
set(handles.plotSpectrumLogFreq, 'TooltipString', tip);

% detect lines
tip = sprintf(['Detect lines above the noise floor estimate by at least the factor specified below.\n'...
'Marks lines on the plot and prints their freq and amp values to the command window.']);
set(handles.plotSpectrumLineDetect, 'TooltipString', tip);

% threshold
tip = sprintf('Specify the threshold factor for detecting lines.');
set(handles.plotSpectrumLineThresh, 'TooltipString', tip);




%--------------------------- Coherence

% plot config
tip = sprintf('Choose the plot layout configuration.');
set(handles.plotCoherencePlots, 'TooltipString', tip);

% window
tip = sprintf('Choose the window function to apply to the data before Fourier transforming.');
set(handles.plotCoherenceWindows, 'TooltipString', tip);

% primary object
tip = sprintf('Choose the primary object against which the coherence of other objects will be computed.');
set(handles.plotCoherencePrimaryChan, 'TooltipString', tip);

% Nfft
tip = sprintf(['Enter the number of seconds of data to use for each fft.']);
set(handles.plotCoherenceNfft, 'TooltipString', tip);

% Noverlap
tip = sprintf('Enter the overlap fraction for subsequent segments (0-1).');
set(handles.plotCoherenceNoverlap, 'TooltipString', tip);



%------------------- Transfer function

% plot config
tip = sprintf('Choose the plot layout configuration.');
set(handles.plotTFPlots, 'TooltipString', tip);

% window
tip = sprintf('Choose the window function to apply to the data before Fourier transforming.');
set(handles.plotTFWindows, 'TooltipString', tip);

% primary object
tip = sprintf('Choose the primary object against which the transfer function of other objects will be computed.');
set(handles.plotTFPrimaryChan, 'TooltipString', tip);

% Nfft
tip = sprintf(['Enter the number of seconds of data to use for each fft.']);
set(handles.plotTFNfft, 'TooltipString', tip);

% Noverlap
tip = sprintf('Enter the overlap fraction for subsequent segments (0-1).');
set(handles.plotTFNoverlap, 'TooltipString', tip);

% open loop
tip = sprintf('Plot 1/TF-1 instead of TF.');
set(handles.plotTFOpenLoop, 'TooltipString', tip);

% cross psd
tip = sprintf('Plot cross power spectral density instead of TF.');
set(handles.plotTFcpsd, 'TooltipString', tip);





%------------------- Spectrogram


% plot config
tip = sprintf('Choose the plot layout configuration.');
set(handles.plotSpectrogramPlots, 'TooltipString', tip);

% window
tip = sprintf('Choose the window function to apply to the data before Fourier transforming.');
set(handles.plotSpectrogramWindows, 'TooltipString', tip);

% color map
tip = sprintf('Choose the color map for the spectrogram display.');
set(handles.plotSpectrogramColorMap, 'TooltipString', tip);

% interpolate
tip = sprintf('Interpolate the spectrogram pixel colors.');
set(handles.plotSpectrogramInterpolate, 'TooltipString', tip);

% norm
tip = sprintf('Normalize the spectrogram by dividing the mean spectrum for each time slice.');
set(handles.plotSpectrogramNormalise, 'TooltipString', tip);

% log y-axis
tip = sprintf('Make the y-axis of the spectrogram logarithmic.');
set(handles.plotSpectrogramLogY, 'TooltipString', tip);

% edge detect
tip = sprintf('Use edge detection.');
set(handles.plotSpectrogramEdges, 'TooltipString', tip);

% Nfft
tip = sprintf(['Enter the number of seconds of data to use for each fft.']);
set(handles.plotSpectrogramNfft, 'TooltipString', tip);

% Noverlap
tip = sprintf('Enter the overlap fraction for subsequent segments (0-1).');
set(handles.plotSpectrogramNoverlap, 'TooltipString', tip);



%------------------- Cross-correlation

% plot config
tip = sprintf('Choose the plot layout configuration.');
set(handles.plotXCorrPlots, 'TooltipString', tip);

% scale options
tip = sprintf('Choose the cross correlation scaling.');
set(handles.plotXCorrScaleopts, 'TooltipString', tip);

% auto-correlation
tip = sprintf('Make autocorrelation of object with itself.');
set(handles.plotXCorrAuto, 'TooltipString', tip);

% primary object
tip = sprintf('Choose the primary object against which the cross correlation of other objects will be computed.');
set(handles.plotXCorrPrimaryChan, 'TooltipString', tip);


%------------------- Histogram

% plot config
tip = sprintf('Choose the plot layout configuration.');
set(handles.plotHistogramPlots, 'TooltipString', tip);

% Nbins
tip = sprintf('Specify the number of bins in the histogram.');
set(handles.plotHistogramBins, 'TooltipString', tip);

% detrend
tip = sprintf('Detrend the data before making the histogram.');
set(handles.plotHistogramDetrend, 'TooltipString', tip);

% lower outliers
tip = sprintf('Specify lower threshold for outlier removal.');
set(handles.plotHistogramLower, 'TooltipString', tip);

% upper outliers
tip = sprintf('Specify upper threshold for outlier removal.');
set(handles.plotHistogramUpper, 'TooltipString', tip);


% END

