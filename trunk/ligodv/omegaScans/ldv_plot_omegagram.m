function ldv_plot_omegagram(handles)

% DV_PLOT_OMEGAGRAM Make omegagram plot of the selected data
% objects.
% 
% 
% $Id: dv_plot_omegagram.m,v 1.18 2012/07/05 15:47:22 michalw Exp $
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

% get spectral parameters
% params.scale = dv_getselectionbox(handles.plotSpectrogramScales);
params.FAR = str2num(get(handles.plotOmegagramFAR, 'String'));
params.qRange = str2num(get(handles.plotOmegagramQrange, 'String'));
params.freqRange = str2num(get(handles.plotOmegagramFreqRange, 'String'));
params.energyLoss = str2num(get(handles.plotOmegagramEnergyLoss, 'String'));
params.whiteningDuration = str2num(get(handles.plotOmegagramWhiteningDuration, 'String'));
params.aspectRatio = str2num(get(handles.plotOmegagramAspectRatio, 'String'));

% log y-axis?
logy = get(handles.plotOmegagramLogY, 'Value');

% use whitening from aux data
omegaNorm = get(handles.plotOmegagramNormMenu, 'Value');

% plot SNR instead of amplitudes
if omegaNorm == 2
  plotNormalize = 1;
else
  plotNormalize = 0;
end

%if plotWhiteningUse && plotNormalize
%  error('### Please select only one of the boxes: "reference normalize" or "flat normalize"')
%end

% check what is selected
if nobjs < 2 && omegaNorm == 3
  %error('You''ve selected only one object, reference normalization not possible!');
  msg = 'You''ve selected only one object, reference normalization not possible!';
      mymsg = sprintf(msg);
      mb = msgbox(mymsg, 'Input Error', 'error');
      waitfor(mb);
  error('### please select at least two data objects for a spectral ratio plot.');
end

% square colormap
params.squaredColorbar = get(handles.plotOmegagramSquaredColorbar, 'Value');

% colormap
cmap = ldv_getselectionbox(handles.plotOmegagramColorMap);

% get unit for y-axis
% unit = get(handles.plotUnitTxt, 'String');
unit = ldv_getYunits(handles);

% get x-limits
xlimStr = get(handles.plotXlims, 'String');
eval(sprintf('xlims = [%s];', xlimStr));
% get y-limits
ylimStr = get(handles.plotYlims, 'String');
eval(sprintf('ylims = [%s];', ylimStr));
% data store
dvout = [];

% search parameters
transientFactor = 4;
outlierFactor = 2.0;
durationInflation = params.aspectRatio(1);
bandwidthInflation = params.aspectRatio(2);
highPassCutoff = params.freqRange(1);
lowPassCutoff = params.freqRange(2);
sampleFrequency = 2^ceil(2+log2(params.freqRange(2)));
whiteningDuration = 2^ceil(4+log2(params.whiteningDuration/highPassCutoff));
startTime = 0;

% parameters that the user should be able to specify
qRange = params.qRange;
frequencyRange = params.freqRange;
maximumEnergyLoss = params.energyLoss;
whiteNoiseFalseRate = params.FAR;

% go through each object
% compute spectra of primary channel
if omegaNorm == 3
  % get the primary object
  pobj = ldv_getprimaryobject(dobjs, handles.plotOmegagramWhitenChan);
  [pt, px, pinfo] = ldv_preparedata(pobj, handles);
  rawSampleFrequency = pobj.data.fs;
  timeRange = length(px)/rawSampleFrequency;
  whiteData = wresample({px}, rawSampleFrequency, sampleFrequency);
  % set-up the omega tiles
  tiling = wtile(timeRange, qRange, frequencyRange, sampleFrequency, ...
                   maximumEnergyLoss, highPassCutoff, lowPassCutoff, ...
                   whiteningDuration, transientFactor);
  [whitenedData coefficients PPSD] = wcondition(whiteData, tiling, []);
end

legendStr = [];
for ob = 1:nobjs
  % get current object
  obj  = dobjs.objs(dobjsidx(ob));
  if omegaNorm < 3 || (obj.id ~= pobj.id)
  
    % prepare data
    [t, x, dinfo] = ldv_preparedata(obj, handles);
  
    % compute spectrogram
    %  [t, f, sxx, info] = dv_spectrogram('Matlab', x, params, obj.data.fs);
    %  f = f+dinfo.f0;
    rawSampleFrequency = obj.data.fs;
    timeRange = length(x)/rawSampleFrequency;
  
    % set-up the omega tiles
    tiling = wtile(timeRange, qRange, frequencyRange, sampleFrequency, ...
                   maximumEnergyLoss, highPassCutoff, lowPassCutoff, ...
                   whiteningDuration, transientFactor);
		 
    % condition (whiten) the data
    rawData = wresample({x}, rawSampleFrequency, sampleFrequency);
    [whitenedData coefficients PSD] = wcondition(rawData, tiling, []);
  
    % make the Q-tile decomposition
    whitenedTransform = wtransform(whitenedData, tiling, outlierFactor); 

    if whiteNoiseFalseRate
      whitenedSignificantsAll = ...
          wthreshold(whitenedTransform, tiling, startTime, whiteNoiseFalseRate, ...
                   [], [], [], [], [], [], [], [], [], PSD);
    end
  
    % build fake info struct
    info.qs = tiling.qs;
    round(info.qs)

    if omegaNorm == 2
      cbtstr = 'SNR'; 
    elseif omegaNorm == 3
        cbtstr = ['Amplitude over noise ratio at ' ldv_gps2utc(pobj.startgps)];
    else
        cbtstr = 'Amplitude [Unknown units]'; 
    end
           
    % object info
    obj.info = structcat(info, dinfo);
    tstr     = omegagram_title(obj);
  
    % set plot xlimit from xlims
    if xlims
      timeLimits = [xlims(1) xlims(2)];
    else
      timeLimits = [];
    end

    % switch through different plot configurations

    hfig = figure;
    if whiteNoiseFalseRate
      h = dv_weventgram(whitenedSignificantsAll, tiling, startTime, [],...
                      timeLimits, [], durationInflation, bandwidthInflation, ...
                      [0 10], not(plotNormalize));
    else
      if omegaNorm == 2
        h = dv_wimagedeconv(whitenedTransform, tiling, startTime, [], ...
                          timeLimits, [], [], [0 10], 256/durationInflation, ...
                            256/bandwidthInflation);
      else
        if omegaNorm == 3
          %only proceed if a FAR Threshold has been set. 
          try
            PSD(:,2) = PSD(:,2)./PPSD(:,2);
          catch e 
            msg = 'Cannot Proceed. Try increasing the FAR Threshold from 0.';
            mb = msgbox(msg,'Input Error', 'error');
            waitfor(mb);
          end
        end	
        h = dv_wimagedeconv(whitenedTransform, tiling, startTime, [], ...
                          timeLimits, [], [], [0 10], 256/durationInflation, ...
                            256/bandwidthInflation, PSD);
      end
    end
    hold on;
    title(tstr);
    set(hfig, 'Name', sprintf('LDV plot object: %s', obj.channel));
  
  
    % plot settings
    hc = colorbar;
    set(get(hc, 'YLabel'), 'String', cbtstr, 'Fontweight', 'bold', 'VerticalAlignment', 'top');
    if params.squaredColorbar
      initialColormap = colormap(cmap);
      % stretch colormap so there is more colors at the upper range
      newColormap = interp1(1:length(initialColormap),initialColormap,...
        (linspace(1,sqrt(length(initialColormap)),length(initialColormap))).^2);
      colormap(newColormap);
    else
      colormap(cmap);
    end
    set(gca, 'YDir', 'reverse');
    set(gca, 'Layer', 'top');
    
    %Hardcode color axis
    if omegaNorm ==3 
        caxis([0 25]);
    end
    
    % log y-axis
    if logy
      set(gca, 'Yscale', 'log');
    end
   
    % add labels and grid
    ldv_xaxis(hfig, xlims)
    ldv_yaxis(hfig, ylims)
    axis xy;
  
    % add to output data
    dvout.type               = 'Omegagram';
    dvout.obj(ob).channel    = obj.channel;
    dvout.obj(ob).info       = obj.info;
    dvout.obj(ob).info.unit  = unit;
    dvout.obj(ob).t          = t;
    dvout.obj(ob).f          = tiling;
    if whiteNoiseFalseRate
      dvout.obj(ob).sxx        = whitenedSignificantsAll;
    else
      dvout.obj(ob).sxx        = whitenedTransform;
    end
  end %end of ~primary loop
end  % end of obj loop

% save output data
if get(handles.plotSaveChk, 'Value')  
  ldv_dataProductSave(dvout)
end

%export output data
if get(handles.plotExportChk, 'Value')
   ldv_dataProductExport(dvout);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get title for spectrogram plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tstr = omegagram_title(obj)

% get settings
includingPrime = obj.data.includingPrime;

% set start and stop
if includingPrime > 0
  startgps = obj.startgps + includingPrime;
else
  startgps = obj.startgps;
end
stopgps  = obj.stopgps;
nsecs    = stopgps - startgps ;

% additional info tag
switch obj.source.type
  case {'hour trends', 'day trends'}
    
  otherwise
    tag = '';
end

% build title    
tstr =  [...
              sprintf('Omegagram of %02d:%s\n', obj.id, ldv_chan2label(obj.channel))...
              sprintf('fs = %d : %ds from %s - %s',...
                  obj.data.fs, nsecs, ldv_gps2utc(startgps), obj.comment)...
          ];

if obj.preproc.heterodyneOn
  tstr = [tstr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
end

