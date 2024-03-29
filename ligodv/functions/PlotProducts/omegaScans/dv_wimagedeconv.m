function handles = dv_wimagedeconv(transforms, tiling, startTime, referenceTime, ...
                                   timeRange, frequencyRange, qRange, ...
                                   normalizedEnergyRange, horizontalResolution, ...
                                   verticalResolution, PSD)
% WSPECTROGRAM Display time-frequency Q transform spectrograms
%
% WSPECTROGRAM displays multi-resolution time-frequency spectrograms of
% normalized tile energy produced by WTRANSFORM.  A separate figure is produced
% for each channel and for each time-frequency plane within the requested range
% of Q values.  The resulting spectrograms are logarithmic in frequency and
% linear in time, with the tile color denoting normalized energy.
%
% usage:
%
%   handles = wspectrogram(transforms, tiling, startTime, referenceTime, ...
%                          timeRange, frequencyRange, qRange, ...
%                          normalizedEnergyRange, horizontalResolution);
%
%     transforms              cell array of q transform structures
%     tiling                  q transform tiling structure
%     startTime               start time of transformed data
%     referenceTime           reference time of plot
%     timeRange               vector range of relative times to plot
%     frequencyRange          vector range of frequencies to plot
%     qRange                  scalar Q or vector range of Qs to plot
%     normalizedEnergyRange   vector range of normalized energies for colormap
%     horizontalResolution    number of data points across image
%     PSD                  measured PSD as outputted by wcondition 
%
%     handles                 matrix of axis handles for each spectrogram
%
% The user can focus on a subset of the times and frequencies available in the
% original transform data by specifying a desired time and frequency range.
% Ranges should be specified as a two component vector, consisting of the
% minimum and maximum value.  Additionally, WSPECTROGRAM can be restricted to
% plot only a subset of the available Q planes by specifying a single Q or a
% range of Qs.  If a single Q is specified, WSPECTROGRAM displays the
% time-frequency plane which has the nearest value of Q in a logarithmic sense
% to the requested value.  If a range of Qs is specified, WSPECTROGRAM displays
% all time-frequency planes with Q values within the requested range.  By
% default all available channels, times, frequencies, and Qs are plotted.  The
% default values can be obtained for any argument by passing the empty matrix
% [].
%
% To determine the range of times to plot, WSPECTROGRAM requires the start time
% of the transformed data, a reference time, and relative time range.  Both the
% start time and reference time should be specified as absolute quantities, but
% the range of times to plot should be specified relative to the requested
% reference time.  The specified reference time is used as the time origin in
% the resulting spectrograms and is also reported in the title of each plot.
%
% If only one time-frequency plane is requested, it is plotted in the current
% figure window.  If more than one spectrogram is requested, they are plotted
% in separate figure windows starting with figure 1.
%
% The optional normalizedEnergyRange specifies the range of values to encode
% using the colormap.  By default, the lower bound is zero and the upper bound
% is autoscaled to the maximum normalized energy encountered in the specified
% range of time, frequency, and Q.
%
% The optional cell array of channel names are used to label the resulting
% figures.
%
% The optional horizontal resolution argument specifies the number data points
% in each frequency row of the displayed image.  The vector of normalized
% energies in each frequency row is then interpolated to this resolution in
% order to produce a rectangular array of data for displaying.  The vertical
% resolution is directly determined by the number of frequency rows available in
% the transform data.  By default, a horizontal resolution of 2048 data points
% is assumed, but a higher value may be necessary if the zoom feature will be
% used to magnify the image.  For aesthetic purposes, the resulting image is
% also displayed with interpolated color shading enabled.
%
% WSPECTROGRAM returns a matrix of axis handles for each spectrogram with
% each channel in a separate row and each Q plane in a separate column.
%
% See also WTILE, WCONDITION, WTRANSFORM, WEVENTGRAM, and WEXAMPLE.

% Shourov K. Chatterji <shourov@ligo.mit.edu>

% $Id: dv_wimagedeconv.m,v 1.2 2012/07/05 09:03:59 michalw Exp $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            hard coded parameters                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of horizontal pixels in image
defaultHorizontalResolution = 2048;
defaultVerticalResolution = 512;

% spectrogram boundary
spectrogramLeft = 0.14;
spectrogramWidth = 0.80;
spectrogramBottom = 0.28;
spectrogramHeight = 0.62;
spectrogramPosition = [spectrogramLeft spectrogramBottom ...
                       spectrogramWidth spectrogramHeight];

% colorbar position
colorbarLeft = spectrogramLeft;
colorbarWidth = spectrogramWidth;
colorbarBottom = 0.12;
colorbarHeight = 0.02;
colorbarPosition = [colorbarLeft colorbarBottom ...
                    colorbarWidth colorbarHeight];

% time scales for labelling
millisecondThreshold = 0.5;
secondThreshold = 3 * 60;
minuteThreshold = 3 * 60 * 60;
hourThreshold = 3 * 24 * 60 * 60;
dayThreshold = 365.25 * 24 * 60 * 60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        process command line arguments                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% verify number of input arguments
error(nargchk(2, 11, nargin, 'struct'));

% apply default arguments
if (nargin < 3) || isempty(startTime),
  startTime = 0;
end
if (nargin < 4) || isempty(referenceTime),
  referenceTime = 0;
end
if (nargin < 5) || isempty(timeRange),
  timeRange = [-Inf Inf];
end
if (nargin < 6) || isempty(frequencyRange),
  frequencyRange = [-Inf Inf];
end
if (nargin < 7) || isempty(qRange),
  qRange = [-Inf Inf];
end
if (nargin < 8) || isempty(normalizedEnergyRange),
  normalizedEnergyRange = [];
end
if (nargin < 9) || isempty(horizontalResolution),
  horizontalResolution = defaultHorizontalResolution;
end
if (nargin < 10) || isempty(verticalResolution),
  verticalResolution = defaultVerticalResolution;
end
if (nargin < 11) || isempty(PSD)
  PSD = 0;
end

% force cell arrays
transforms = wmat2cell(transforms);

% force one dimensional cell arrays
transforms = transforms(:);

% determine number of channels
numberOfChannels = length(transforms);

% make channelNames array
for channelNumber = 1 : numberOfChannels,
  if isfield(transforms{channelNumber},'channelName'),
    channelNames{channelNumber} = transforms{channelNumber}.channelName;
  else
    channelNames{channelNumber} = ['Channel ' int2str(channelNumber)];
  end
end

% force ranges to be monotonically increasing column vectors
timeRange = unique(timeRange(:));
frequencyRange = unique(frequencyRange(:));
qRange = unique(qRange(:));
if ~isempty(normalizedEnergyRange),
  normalizedEnergyRange = unique(normalizedEnergyRange(:));
end

% store requested frequency range
requestedFrequencyRange = frequencyRange;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       validate command line arguments                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% validate channel names
if ~isempty(channelNames) && (length(channelNames) ~= numberOfChannels),
  error('channel names is inconsistent with number of transform channels');
end

% check for valid discrete Q-transform tile structure
if ~strcmp(tiling.id, 'Discrete Q-transform tile structure'),
  error('The first argument is not a valid Q-transform tiling.');
end

% check for valid discrete Q-transform transform structure
for channelNumber = 1 : numberOfChannels,
  if ~strcmp(transforms{channelNumber}.id, ...
             'Discrete Q-transform transform structure'),
    error('The second argument is not a valid Q-transform result.');
  end
end

% Check for two component range vectors
if length(timeRange) ~= 2,
  error('Time range must be two component vector [tmin tmax].');
end
if length(frequencyRange) ~= 2,
  error('Frequency range must be two component vector [fmin fmax].');
end
if length(qRange) > 2,
  error('Q range must be scalar or two component vector [Qmin Qmax].');
end
if ~isempty(normalizedEnergyRange) && length(normalizedEnergyRange) ~= 2,
  error('Normalized energy range must be two component vector [Zmin Zmax].');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         identify q planes to display                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if non-zero Q range is requested,
if length(qRange) == 2,

  % find planes within requested Q range
  planeIndices = find((tiling.qs >= min(qRange)) & ...
                      (tiling.qs <= max(qRange)));

% otherwise, if only a single Q is requested,
else

  % find plane with Q nearest the requested value
  [ignore, planeIndices] = min(abs(log(tiling.qs / qRange)));

% continue
end

% number of planes to display
numberOfPlanes = length(planeIndices);

% initialize handle vector
handles = gobjects(numberOfChannels, numberOfPlanes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          identify times to display                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% default start time for display is start time of available data
if timeRange(1) == -Inf,
  timeRange(1) = startTime - referenceTime + tiling.whiteningDuration;
end

% default stop time for display is stop time of available data
if timeRange(2) == +Inf,
  timeRange(2) = startTime - referenceTime + tiling.duration - tiling.whiteningDuration;
end

% validate requested time range
if (timeRange(1) < startTime - referenceTime) || ...
   (timeRange(2) > startTime - referenceTime + tiling.duration),
  error('requested time range exceeds available data');
end

% vector of times to display
times = linspace(min(timeRange), max(timeRange), horizontalResolution);
timesStep = timeRange(2) - timeRange(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           begin loop over channels                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf
hold on

% loop over channels
for channelNumber = 1 : numberOfChannels,

  % initialize maximum normalized energy
  maximumNormalizedEnergy = 0;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                       initialize display matrix                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % initialize matrix of normalized energies for display
    normalizedEnergies = zeros(verticalResolution, horizontalResolution);


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                          begin loop over q planes                          %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % loop over planes to display
  for plane = 1 : numberOfPlanes,

    % index of plane in tiling structure
    planeIndex = planeIndices(plane);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                   identify frequency rows to display                     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % default minimum frequency is minimum frequency of available data
    if requestedFrequencyRange(1) == -Inf,
      frequencyRange(1) = tiling.planes{planeIndex}.minimumFrequency;
    else
      frequencyRange(1) = requestedFrequencyRange(1);
    end

    % default maximum frequency is maximum frequency of available data
    if requestedFrequencyRange(2) == +Inf,
      frequencyRange(2) = tiling.planes{planeIndex}.maximumFrequency;
    else
      frequencyRange(2) = requestedFrequencyRange(2);
    end

    % validate selected frequency range
    if (frequencyRange(1) < tiling.planes{planeIndex}.minimumFrequency) || ...
       (frequencyRange(2) > tiling.planes{planeIndex}.maximumFrequency),
      error('requested frequency range exceeds available data');
    end

    % vector of frequencies in plane
    frequencies = tiling.planes{planeIndex}.frequencies;

    % find rows within requested frequency range
    rowIndices = find((frequencies >= min(frequencyRange)) & ...
                      (frequencies <= max(frequencyRange)));

    % pad by one row if possible
    if rowIndices(1) > 1,
      rowIndices = [rowIndices(1) - 1 rowIndices];
    end
    if rowIndices(end) < length(frequencies),
      rowIndices = [rowIndices rowIndices(end) + 1];
    end

    % vector of frequencies to display
    frequencies = frequencies(rowIndices);

    % number of rows to display
    numberOfRows = length(rowIndices);
    frequenciesPlot = logspace(log10(min(frequencyRange)),log10(max(frequencyRange)),verticalResolution);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                     begin loop over frequency rows                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % loop over rows
    for row = 1 : numberOfRows,

      % index of row in tiling structure
      rowIndex = rowIndices(row);

      % vector of times in plane
      rowTimes = ...
          (0 :  tiling.planes{planeIndex}.rows{rowIndex}.numberOfTiles - 1) ... 
	  * tiling.planes{planeIndex}.rows{rowIndex}.timeStep + ...
                 (startTime - referenceTime);

      % find tiles within requested time range
      padTime = 0.5*tiling.planes{planeIndex}.rows{rowIndex}.timeStep;
      tileIndices = find((rowTimes >= min(timeRange) - padTime) & ...
                         (rowTimes <= max(timeRange) + padTime));

      % vector of times to display
      rowTimes = rowTimes(tileIndices);
      
      %Check if we have data
      try
          if PSD
          end
      catch e
          msg = 'Cannot Proceed. Try increasing the FAR Threshold from 0.';
            mb = msgbox(msg,'Input Error', 'error');
            waitfor(mb);
      end
      
          
      if PSD
        % Compute the amplitude (in sqrt(Hz) units) based on the PSD floor
        % (harmonic average windowed by the bi-quadratic window of omega)
        % FIXME: Haven't checked if it is correct, could be wrong by a factor sqrt(2) or 2

        % find frequencies in PSD for given tile 
        qPrime = tiling.planes{plane}.q / sqrt(11);
        [tmp nearestIndex] = min(abs(PSD(:,1) - tiling.planes{plane}.rows{row}.frequency));
        inBandMask = abs(PSD(:,1) - tiling.planes{plane}.rows{row}.frequency)*...
            qPrime < tiling.planes{plane}.rows{row}.frequency & ...
            PSD(:,1) >= tiling.highPassCutoff & PSD(:,1) <= tiling.lowPassCutoff;
        psdIndices = union(nearestIndex,find(inBandMask));
        % dimensionless frequency vector for window construction
        windowArgument = abs(PSD(psdIndices,1) - tiling.planes{plane}.rows{row}.frequency) * ...
            qPrime / tiling.planes{plane}.rows{row}.frequency;
        % bi square window function
        window = (1 - windowArgument.^2).^2;
        window = window/norm(window);
        rowNormalizedEnergies = ...
             sqrt(2*transforms{channelNumber}.planes{plane}.rows{row} ...
                   .normalizedEnergies(tileIndices) / ...
                  dot(window.^2,1./PSD(psdIndices,2)));
      else
        rowNormalizedEnergies = sqrt(2*transforms{channelNumber}.planes{planeIndex} ...
                                     .rows{rowIndex}.normalizedEnergies(tileIndices));
      end
      
      % update maximum normalized energy
      maximumNormalizedEnergy = max(max(rowNormalizedEnergies), ...
                                    maximumNormalizedEnergy);
      
      % interpolate to desired horizontal resolution
      if  (times(2)-times(1)) >= (rowTimes(2) - rowTimes(1))
        rowNormalizedEnergies = accumarray(1+round((rowTimes'-times(1))/(times(2)-times(1))),...
                                           rowNormalizedEnergies',[],@max)';
      else
        rowNormalizedEnergies = interp1(rowTimes, rowNormalizedEnergies, times, ...
                                        'nearest');
      end

      
      % ---- insert into display matrix
      % a given tile affects many frequencies, insert only frequencies that
      % are above the half maximum amplitude of the frequency window, and
      % include this window in the displayed SNR, so that a single loud
      % tile reproduce the window scaled by the tile SNR
      qPrime = tiling.planes{plane}.q / sqrt(11);
      freqMask = abs(frequenciesPlot - tiling.planes{plane}.rows{row}.frequency)*...
          qPrime < tiling.planes{plane}.rows{row}.frequency & ...
          frequenciesPlot >= tiling.highPassCutoff & frequenciesPlot <= tiling.lowPassCutoff;
      windowArgument = abs(frequenciesPlot - tiling.planes{plane}.rows{row}.frequency) * ...
          qPrime / tiling.planes{plane}.rows{row}.frequency;
      window = (1 - windowArgument.^2).^2;      
      window(window<0.5) = 0;
      normalizedEnergies(freqMask, :) = max(normalizedEnergies(freqMask, :),window(freqMask)'*rowNormalizedEnergies);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                      end loop over frequency rows                        %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % end loop over rows
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                         set colormap scaling                             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if PSD
    colormapScale = [0 maximumNormalizedEnergy];
  else
    % if normalized energy range is not specified
    if isempty(normalizedEnergyRange),

      % normalized energy range to code on colormap
      colormapScale = [0 maximumNormalizedEnergy];

    % or if autoscaling of upper limit is requested,
    elseif normalizedEnergyRange(2) == Inf,

      % normalized energy range to code on colormap
      colormapScale = [normalizedEnergyRange(1) maximumNormalizedEnergy];

    % otherwise,
    else

      % use specified range
      colormapScale = normalizedEnergyRange(:).';

    % continue
    end
  end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                            plot spectrogram                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %                           end loop over q planes                           %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % end loop over planes
  end

    % plot spectrogram
    if abs(diff(timeRange)) < millisecondThreshold,
      surf(times * 1e3, frequenciesPlot, normalizedEnergies, normalizedEnergies);
    elseif abs(diff(timeRange)) < secondThreshold,
      surf(times * 1, frequenciesPlot, normalizedEnergies, normalizedEnergies);
    elseif abs(diff(timeRange)) < minuteThreshold,
      surf(times / 60, frequenciesPlot, normalizedEnergies, normalizedEnergies);
    elseif abs(diff(timeRange)) < hourThreshold,
      surf(times / 3600, frequenciesPlot, normalizedEnergies, normalizedEnergies);
    elseif abs(diff(timeRange)) < dayThreshold,
      surf(times / 86400, frequenciesPlot, normalizedEnergies, normalizedEnergies);
    else
      surf(times / 31557600, frequenciesPlot, normalizedEnergies, normalizedEnergies);
    end


    % reset figure
    set(gca, 'FontSize', 16);

    % apply colormap scaling
    colormap('default');
    caxis(colormapScale);

    % set axis range
    if abs(diff(timeRange)) < millisecondThreshold,
      axis([min(timeRange) * 1e3 max(timeRange) * 1e3 ...
            min(frequencyRange) max(frequencyRange)]);
    elseif abs(diff(timeRange)) < secondThreshold,
      axis([min(timeRange) * 1 max(timeRange) * 1 ...
            min(frequencyRange) max(frequencyRange)]);
    elseif abs(diff(timeRange)) < minuteThreshold,
      axis([min(timeRange) / 60 max(timeRange) / 60 ...
            min(frequencyRange) max(frequencyRange)]);
    elseif abs(diff(timeRange)) < hourThreshold,
      axis([min(timeRange) / 3600 max(timeRange) / 3600 ...
            min(frequencyRange) max(frequencyRange)]);
    elseif abs(diff(timeRange)) < dayThreshold,
      axis([min(timeRange) / 86400 max(timeRange) / 86400 ...
            min(frequencyRange) max(frequencyRange)]);
    else
      axis([min(timeRange) / 31557600 max(timeRange) / 31557600 ...
            min(frequencyRange) max(frequencyRange)]);
    end

    % set view angle
    view([0 0 1]);

    % disable coordinate grid
    grid off;

    % enable interpolated shading
    shading interp;

    % set y axis properties
    ylabel('Frequency [Hz]');
    set(gca, 'TickDir', 'out');
    set(gca, 'TickLength', [0.01 0.025]);

    % % set vertical height based on frequency range
    % frequencyOctaves = log2(max(frequencies) / min(frequencies));
    % frequencyOctaves = max(frequencyOctaves, 6);
    % frequencyOctaves = min(frequencyOctaves, 10.5);
    % set(gcf, 'PaperPosition', [0.25 0.25 8.0 frequencyOctaves]);
    % % the axis position property should also be adjusted

    % set x axis properties
    if abs(diff(timeRange)) < millisecondThreshold,
      xlabel('Time [milliseconds]');
    elseif abs(diff(timeRange)) < secondThreshold,
      xlabel('Time [seconds]');
    elseif abs(diff(timeRange)) < minuteThreshold,
      xlabel('Time [minutes]');
    elseif abs(diff(timeRange)) < hourThreshold,
      xlabel('Time [hours]');
    elseif abs(diff(timeRange)) < dayThreshold,
      xlabel('Time [days]');
    else
      xlabel('Time [years]');
    end

    % set title properties
    titleString = sprintf('%s at %.3f with Q of %.1f', ...
                          channelNames{channelNumber}, referenceTime, ...
                          tiling.planes{planeIndex}.q);
    titleString = strrep(titleString, '_', '\_');
    title(titleString);

    % set figure background color
    set(gca, 'Color', [1 1 1]);
    set(gcf, 'Color', [1 1 1]);
    set(gcf, 'InvertHardCopy', 'off');
    shading flat

    % append current axis handle to list of handles
    handles(channelNumber, plane) = gca;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            end loop over channels                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% end loop over channels
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          return to calling function                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% return to calling function
return;
