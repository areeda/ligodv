function [x,fs,preproc,unitX,unitY] = ldv_getchanneldata(params, handles)
% LDV_GETCHANNELDATA Get data for a single channel and time.
%
% M Hewitson 28-09-06
%
% $Id$
%

% get the data retrieval mode
dvmode = ldv_getselectionbox(handles.dvmode);

% unpack parameters for different data retieval modes
switch dvmode
    case {'NDS Server', 'NDS2 Server'}
        [dtype, server, port, startgps, stopgps, channel] =...
            unpackParams(dvmode, params);
        %         channel = deblank(regexprep(channel,'{(\w*)}',''));

    case 'LDR Server'
        [dtype, startgps, stopgps, channel] =...
            unpackParams(dvmode, params);

    otherwise
        error('### unknown dataviewer mode');
end

% get settings
settings = getappdata(handles.main, 'settings');

% some defaults
x  = [];
fs = 0;

% get preprocessing commands
preproc.heterodyneOn = get(handles.preprocHet, 'Value');
preproc.resample.R   = ldv_getresamplefactor(handles);
preproc.whitening    = get(handles.preprocWhitening, 'Value');
preproc.math.cmd     = get(handles.preprocMathInput, 'String');

if isempty(preproc.math.cmd)
    preproc.math.cmd = 'u';
end

% get heterodyne frequency
hStr = get(handles.preprocF0, 'String');
if isempty(hStr)
    preproc.f0 = 0;
else
    preproc.f0 = str2double(hStr);
end

% we can split into smaller time segments here
nsecs    = stopgps - startgps;
secsleft = nsecs;

% For the NDS client we seem to need to pass it the full
% channel list !!??
serverchannels = getappdata(handles.main, 'FullChannelList');

% do we need extra data for resampling?
if preproc.resample.R > 1
    % we need one second of data to get the sample rate
    switch dvmode
        case 'NDS Server'
            [xi,fsi]  = ldv_getchanneldatasegment(dtype, server, port,...
                startgps, startgps+1, channel, handles, serverchannels);
            unitX = 'Time (sec)';
            unitY = 'V';
        case  'NDS2 Server'
            [xi,fsi]  = ldv_getNDS2data(dtype, server, port,...
                startgps, startgps+1, channel, handles, serverchannels);
            unitX = 'Time (sec)';
            unitY = ldv_setunit(handles);
        case 'Frame File'
            [xi,fsi,unitX,unitY]  = ldv_getframechanneldatasegment(startgps, startgps, channel, handles);
        otherwise
            error('### unknown dataviewer mode');
    end
    gd = preproc.resample.R*settings.resample.L-1;
    Nextra = ceil(gd/fsi);
else
    Nextra = 0;
end

% do we need extra for resampling?
if preproc.whitening
    Nextra = Nextra + 2;
end

% what step size to use?
step = getStepSize(nsecs, Nextra, dvmode, params);

% loop through segments
tsteps = startgps:step:stopgps;

% don't get more steps if last one is exactly stopgps (fixes bug found by
% Chris Wipf)
if max(tsteps)==stopgps
    tsteps = tsteps(1:max([1 length(tsteps)-1]));
end

nsecs  = stopgps-startgps;

for ts=tsteps

    % update GUI
    drawnow;

    % how much data to get?
    tend = ts+step;
    N    = (tend-ts);
    if N>secsleft
        tend = ts+secsleft;
        N    = (tend-ts);
    end
    ldv_disp('+ processing segment %d, getting %d secs', ts, N);
    ldv_disp('+ getting data from %d to %d (Nextra=%d)', ts-Nextra, tend+Nextra, Nextra);
    % get segment data
    %  - we get Nextra seconds for resample filtering and (later) IIR filters
    switch dvmode
        case 'NDS Server'
            [xi,fsi]  = ldv_getchanneldatasegment(dtype, server, port,...
                ts-Nextra, tend+Nextra, channel, handles, serverchannels);
            unitX = 'Time (sec)';
            unitY = ldv_setunit(handles);

            % workaraound for trend data: NDS server returns fsi=16384 for
            % second trend data! So we will hardwire this.
            if strcmp(params.dtype, 'second trends')
                fsi = 1;
            end

            if strcmp(params.dtype, 'minute trends')
                fsi = 1/60;
            end

            if strcmp(params.dtype, 'hour trends') || strcmp(params.dtype, 'blrms trends')
                fsi = 1/360;
            end

            if strcmp(params.dtype, 'day trends')
                fsi = 1/86400;
            end

        case 'NDS2 Server'
            [xi,fsi]  = ldv_getNDS2data(dtype, server, port,...
                ts-Nextra, tend+Nextra, channel, handles, serverchannels);
            unitX = 'Time (sec)';
            unitY = ldv_setunit(handles);
            
            % workaraound for trend data: NDS2 server returns fsi=0 for
            % second trend data! So we will hardwire this.
            if strcmp(params.dtype, 'second trends')
                fsi = 1;
            end

            if strcmp(params.dtype, 'minute trends')
                fsi = 1/60;
            end

            if strcmp(params.dtype, 'hour trends') || strcmp(params.dtype, 'blrms trends')
                fsi = 1/360;
            end

            if strcmp(params.dtype, 'day trends')
                fsi = 1/86400;
            end

        case 'LDR Server'
            [xi,fsi,unitX,unitY]  = ldv_getframechanneldatasegment(ts-Nextra, tend+Nextra, channel, handles);

        otherwise
            error('### unknown dataviewer mode');
    end

    %--------FOR TESTING
    %     f = 330;
    %     nsecs = length(xi)/fsi;
    %     t  = [linspace(0, nsecs-1/fsi, nsecs*fsi)].';
    %     xi = randn(length(xi),1) + 100.*sin(2*pi*f*t);

    %-------- do preprocessing

    if preproc.heterodyneOn
        ldv_disp('+ preprocessing heterodyne at %f Hz', preproc.f0);
        xi = (ldv_heterodyne(xi, fsi, preproc.f0));
    end

    % check whether downsampling requested
    if preproc.resample.R ~= 1
        ldv_disp('+ preprocessing resample');
    end

    % if this is the first segment, we build the preprocessing lowpass filter
    if ts==tsteps(1) && preproc.resample.R > 1
        fc = 0.90*fsi/2/preproc.resample.R;
        L = settings.resample.L;
        lpfilt = ldv_FIRlowpass(preproc.resample.R, L, fc, fsi, 'lowpass');
        %       fvtool(lpfilt.a);
    end

    % if this is the first segment we can build whitening filter
    if ts==startgps && preproc.whitening
        % build whitening filter
        hpfilt = ldv_highpass(1, fsi, 4, fsi/2/preproc.resample.R/64);
        wfilt  = ldv_mkwhiteningfilter(xi, fsi, fsi/4, hpfilt);
        %       fvtool(wfilt.a);
    end

    % apply whitening filter?
    if preproc.whitening
        ldv_disp('  - whitening data [ntaps = %d]', wfilt.ntaps);
        wfilt.hist  = zeros(size(wfilt.hist));
        [xi, Zf] = filter(wfilt.a, 1, xi, wfilt.hist);
        wfilt.hist = Zf;
    else
        wfilt.gd = 0;
    end

    % if we are downsampling
    if preproc.resample.R > 1
        ldv_disp('  - resampling segment x%d', preproc.resample.R);
        lpfilt.hist  = zeros(size(lpfilt.hist));
        [xi, Zf] = filter(lpfilt.a, 1, xi, lpfilt.hist);
        lpfilt.hist = Zf;
    else
        lpfilt.gd = 0;
    end

    % if we did any filtering, we need to remove the gate delay
    if preproc.resample.R > 1 || preproc.whitening
        % remove group delay
        gd = lpfilt.gd + wfilt.gd;
        ldv_disp('  - removing group delay of %d samples', gd);
        xi = xi(1+gd+Nextra*fsi : end-Nextra*fsi+gd);
    end
    % if we are downsampling
    if preproc.resample.R > 1
        % decimate
        xi = downsample(xi, preproc.resample.R);
        fs = fsi/preproc.resample.R;
    else
        fs = fsi;
    end

    if strcmp(preproc.math.cmd,'u') ~= 1;
        ldv_disp(['+ preprocessing math ',preproc.math.cmd]);
        u=xi;
        eval(sprintf('xi=%s;', preproc.math.cmd));
    end

    % store data segment
    x = [x;xi];

    % count how much data we already got
    secsgot  = tend - ts;
    secsleft = secsleft - secsgot;
    sstr = sprintf('* %2.1f%% data retrieved for %s', 100*((nsecs-secsleft)/nsecs), channel);
    set(handles.dvStatus, 'String', sstr);
end

end

%--------------------------------------------------------------------------
function varargout = unpackParams(dvmode, params)

% UNPACKPARAMS unpack the parameters depending on which dv mode we are
% in.


switch dvmode

    case {'NDS Server', 'NDS2 Server'}
        varargout{1} = params.dtype;
        varargout{2} = params.server;
        varargout{3} = params.port;
        varargout{4} = params.startgps;
        varargout{5} = params.stopgps;
        varargout{6} = params.channel;

    case 'Frame File'
        varargout{1} = params.dtype;
        varargout{2} = params.startgps;
        varargout{3} = params.stopgps;
        varargout{4} = params.channel;

    otherwise
        error('### unknown dataviewer mode');
end


end

%% ------------------------------------------------------------------------
function step = getStepSize(nsecs, Nextra, dvmode, params)
% Get the step size for data chunks
% Found that for NDS larger step size gives faster downloads

step     = 10.;

switch dvmode
    case {'NDS Server', 'NDS2 Server'}
        if strcmp(params.dtype, 'raw data')
            if nsecs >= 30
                step = 30;
            end
            if nsecs >= 60
                step = 60;
            end
            if nsecs >= 120
                step = 120;
            end
            if nsecs >= 240
                step = 240;
            end
            if nsecs >= 480
                step = 480;
            end
            if nsecs >= 960*2
                step = 960;
            end
            while step/2 < Nextra
                step = step *2;
            end
        end

        if strcmp(params.dtype, 'second trends')
            if nsecs >= 30
                step = 30;
            end
            if nsecs >= 60
                step = 60;
            end
            if nsecs >= 120
                step = 120;
            end
            if nsecs >= 300
                step =  240;
            end
            if nsecs >= 600
                step =  480;
            end
            if nsecs >= 1200
                step =   960;
            end
            if nsecs >= 2400
                step = 1920;
            end
            if nsecs >= 4800
                step =  3840;
            end
            if nsecs >= 9600
                step =  7680;
            end
            if nsecs >= 19200
                step =  15360;
            end
            if nsecs >= 38400
                step =  30720;
            end
            if nsecs >= 76800
                step =  61440;
            end
        end

        % Playing around with step size reveals that NDS data retrieval is
        % fastest with fewer chunks - so doubled step size.

        if strcmp(params.dtype, 'minute trends')
            if nsecs >= 30
                step = 30;
            end
            if nsecs >= 60
                step = 60;
            end
            if nsecs >= 120
                step = 120;
            end
            if nsecs >= 240
                step =  240;
            end
            if nsecs >= 480
                step =  480;
            end
            if nsecs >= 960
                step =   960;
            end
            if nsecs >= 1920
                step = 1920;
            end
            if nsecs >= 3840
                step =  3840;
            end
            if nsecs >= 7680
                step =  7680;
            end
            if nsecs >= 15360
                step =  15360;
            end
            if nsecs >= 30720
                step =  30720;
            end
            if nsecs >= 61440
                step =  61440;
            end
            if nsecs >= 122880
                step = 122880;
            end
            if nsecs >= 307200
                step = 122880*2;
            end
            if nsecs >= 614400
                step = 245760*2;
            end
        end
end
end
