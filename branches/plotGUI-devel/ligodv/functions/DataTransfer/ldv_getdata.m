function dobjs = ldv_getdata(varargin)
%
% Get data, contact the appropriate server and request each time interval
%   for each channel
%
% M Hewitson 28-09-06
%
% $Id$
%

    handles = varargin{1};

    % get settings
    settings = getappdata(handles.main, 'settings');

    % get the data retrieval mode
    dvmode = ldv_getselectionbox(handles.dvmode);

    % prepare input parameters
    params = packParams(dvmode, varargin{2:end});

    % append trend type to channel names
    if strcmp(params.dtype, 'second trends') || strcmp(params.dtype, 'minute trends')
        stat = ldv_getgdstat(handles);
        for k=1:size(params.channels,1)
            chnam=params.channels(k,:);
            p=strfind(chnam,' ');
            if (length(p) > 1)
                p=p(1);
                chnam = chnam(1:p-1);
            end

            if strcmp(stat,'max,mean,min')
                chanstemp(k+3*(k-1)+0) = strcat({chnam},'.max');
                chanstemp(k+3*(k-1)+1) = strcat({chnam},'.mean');
                chanstemp(k+3*(k-1)+2) = strcat({chnam},'.min');
            elseif strcmp(stat,'max,min')
                chanstemp(k+2*(k-1)+0) = strcat({chnam},'.max');
                chanstemp(k+2*(k-1)+1) = strcat({chnam},'.min');
            else
                chanstemp(k) = strcat({chnam},'.',stat);
            end
        end
        params.channels = char(chanstemp);
    end

    % set empty data objects
    dobjs.nobjs = 0;
    dobjs.objs  = [];

    % do we need extra data to prime IIR filters?
    getPrime = get(handles.dv_getPrimeData, 'Value');
    dunit = ldv_getFileUnit(params.dtype);
    if getPrime > 0
        primeTime = settings.primelength*dunit;
    else
        primeTime = 0;
    end

    % loop through channels and times
    ntimes = params.times.ntimes;
    nchans = size(params.channels,1);
    ermsg = ''; % we'll put our notes on problems here
    goodDataMsg = '';  % records successful transfers

    % display progress dialog
    [progBar, tsec] =TransProgbarSetup(params, primeTime);
    progBar.startTiming(tsec);  %
    
    for time=1:ntimes
        for ch=1:nchans

            t0 = clock;

            channel  = params.channels(ch,:);
            startgps = params.times.t(time).startgps-primeTime;
            stopgps  = params.times.t(time).stopgps;

            % If in NDS Server mode, we need to adjust for trend data
            switch dvmode
                case {'NDS Server', 'NDS2 Server'}

                    if strcmp(params.dtype, 'second trends')
                        fsize    = 1;
                        % make sure we get an integer GPS second
                        startgps = startgps - mod(startgps, fsize);
                        stopgps  = stopgps - mod(stopgps,fsize);
                    end

                    if strcmp(params.dtype, 'minute trends')
                        fsize    = 60;
                        % make sure we get an integer GPS minute (This is
                        % needed to get the correct timing)
                        startgps = startgps - mod(startgps, fsize);
                        % get at least one minute
                        if (stopgps - startgps) < 60
                            stopgps  = stopgps - mod(stopgps,fsize) + fsize;
                        else
                            stopgps  = stopgps - mod(stopgps,fsize);
                        end
                    end

                case 'LDR Server'

                    % nothing at the moment

                otherwise
                    error('### unknown dataviewer mode');
            end


            % finalise input parameters
            params.channel  = deblank(channel);
            params.startgps = startgps;
            params.stopgps  = stopgps;
            ldv_disp('* getting channel %s for %d - %d', channel, startgps, stopgps);
            x=[];   % just is 
            fs=0;
            try
               % transProgSetTime(time,ch,params,progBar);
                [x,fs,preproc,unitX,unitY] = ldv_getchanneldata(params, handles,progBar);
            catch e
                % we're in an inner loop just record the error and display
                % them all at once when we're done.
                ermsg = [ermsg sprintf('-%s: (%d, +%d)\n   %s - %s\n', ...
                    params.channel, startgps, stopgps-startgps, e.identifier, e.message)];
            end

            %----- build data object
            if isempty(x)
                ermsg = [ermsg sprintf(' %s: No data available\n\n', channel)];
            else
                dobjs.nobjs = dobjs.nobjs + 1;
                dobjs.objs(dobjs.nobjs).id = -ch;

                % set data object channel name
                dobjs.objs(dobjs.nobjs).channel  = params.channel;

                % set data object times and comment
                dobjs.objs(dobjs.nobjs).startgps = params.startgps;
                dobjs.objs(dobjs.nobjs).stopgps  = params.startgps + length(x)/fs;
                dobjs.objs(dobjs.nobjs).comment  = params.times.t(time).comment;

                % source
                dobjs.objs(dobjs.nobjs).source.type       = params.dtype;
                switch dvmode
                    case {'NDS Server', 'NDS2 Server'}
                        dobjs.objs(dobjs.nobjs).source.server     = params.server;
                        dobjs.objs(dobjs.nobjs).source.port       = params.port;
                    case 'Frame File'
                        dobjs.objs(dobjs.nobjs).source.server     = '';
                        dobjs.objs(dobjs.nobjs).source.port       = -1;
                    otherwise
                        error('### unknown dataviewer mode');
                end

                % data
                dobjs.objs(dobjs.nobjs).data.x               = x;
                if strcmp(params.dtype, 'raw data') || strcmp(params.dtype, 'reduced data')
                    dobjs.objs(dobjs.nobjs).data.fs          = fs;
                end
                dobjs.objs(dobjs.nobjs).data.unitX           = unitX;
                dobjs.objs(dobjs.nobjs).data.unitY           = unitY;
                dobjs.objs(dobjs.nobjs).data.includingPrime  = primeTime;

                % workaraound for trend data: NDS server returns fs=16384 for
                % second trend data! So we will hardwire this.

                if strcmp(params.dtype, 'second trends')
                    dobjs.objs(dobjs.nobjs).data.fs = 1;
                end

                if strcmp(params.dtype, 'minute trends')
                    dobjs.objs(dobjs.nobjs).data.fs = 1/60;
                end

                % adjust for hour/day trends
                if strcmp(params.dtype, 'hour trends') || strcmp(params.dtype, 'blrms trends')
                    dobjs.objs(dobjs.nobjs).data.fs = 1/3600;
                end

                if strcmp(params.dtype, 'day trends')
                    dobjs.objs(dobjs.nobjs).data.fs = 1/86400;
                end


                % preprocessing
                dobjs.objs(dobjs.nobjs).preproc = preproc;

                % filters
                dobjs.objs(dobjs.nobjs).filters.nfilts = 0;
                dobjs.objs(dobjs.nobjs).filters.filts  = [];
                dobjs.objs(dobjs.nobjs).filters.apply  = 0;

                ldv_disp('* got %d secs of data for %s in %2.2f secs',...
                    (stopgps-startgps), params.channel, etime(clock, t0));
                fprintf('\n')
                goodDataMsg = [goodDataMsg sprintf('+%s: %d sec received\n',...
                    params.channel, (stopgps-startgps))];
            end  % good data recieved
            drawnow();
        end % each time interval in list
    end % each channel in list

    if (length(ermsg) > 0)
        
        if (length(goodDataMsg) > 0)
            ermsg = sprintf('PROBLEM GETTING DATA:\n\n%s',ermsg);
            ermsg = [sprintf('%s\n---\nSUCCESSFUL TRANSFERS:\n\n%s',...
                ermsg, goodDataMsg)];
        end
        disp(ermsg);
        ldvMsgbox(ermsg,'Problem(s) getting data','warn');
    end
    drawnow();      % update the Data pool window.
    progBar.done();  % close the progress bar dialog
end


%% ------------------------------------------------------------------------
function params = packParams(varargin)

% Pack the input parameters based on the dv mode.
%

dvmode = varargin{1};

switch dvmode
    case {'NDS Server', 'NDS2 Server'}
        params.dtype     = varargin{2};
        params.server    = varargin{3};
        params.port      = varargin{4};
        params.times     = varargin{5};
        params.channels  = varargin{6};

    case 'LDR Server'

        params.times     = varargin{2};
        params.channels  = varargin{3};
        params.dtype     = 'frame data';

    otherwise
        error('### unknown dataviewer mode');
end
end

