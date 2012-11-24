function [x,fs,preproc,unitX,unitY] = ...
    ldv_getchanneldata(params, handles,progBar)
% LDV_GETCHANNELDATA Get data for a single channel and time.
%
% M Hewitson 28-09-06
%
% $Id$
% Input:
%    params  - packed parameters for transfer
%    handles - GUI handles for other parameters we need (should be included
%              in params in the future
%    progBar - progressBar, a java object
%    tsec    - total seconds of data in the whole request (not just this
%              channel)
%    curSec  - our starting position in that total time
%--
% Output:
%    x       - preprocessed data vector
%    fs      - sample frequency
%    preproc - structure with the preprocessing command(s)
%    unitX   - text of X units usually seconds
%    unitY   - text of Y units, depends on preprocessing
%    curSec  - our ending position in total time (for progress bar)

% get the data retrieval mode
dvmode = ldv_getselectionbox(handles.dvmode);

% unpack parameters for different data retieval modes
switch dvmode
    case {'NDS Server', 'NDS2 Server'}
        [dtype, server, port, startgps, stopgps, channel] =...
            unpackParams(dvmode, params);
    otherwise
        error('### unknown dataviewer mode');
end

if (iscell(channel))
    channel = char(channel);
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


% do we need extra data for resampling?
if preproc.resample.R > 1
    % we need one second of data to get the sample rate
    
        [xi,fsi,ign]  = ldv_getNDS2data(dtype, server, port,...
            startgps, startgps+1, channel, handles, serverchannels,progBar);
        unitX = 'Time (sec)';
        unitY = ldv_setunit(handles);
       
    gd = preproc.resample.R*settings.resample.L-1;
    Nextra = ceil(gd/fsi);
else
    Nextra = 0;
end

% do we need extra for resampling?
if preproc.whitening
    Nextra = Nextra + 2;
end


[xi,fsi]  = ldv_getNDS2data(dtype, server, port,...
    startgps-Nextra, stopgps, channel, handles,progBar);
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
    fsi = 1/3600;
end

if strcmp(params.dtype, 'day trends')
    fsi = 1/86400;
end


%-------- do preprocessing

if preproc.heterodyneOn
    ldv_disp('+ preprocessing heterodyne at %f Hz', preproc.f0);
    xi = (ldv_heterodyne(xi, fsi, preproc.f0));
end

% check whether downsampling requested
if preproc.resample.R ~= 1
    ldv_disp('+ preprocessing resample');
end

% we build the preprocessing lowpass filter
if preproc.resample.R > 1
    fc = 0.90*fsi/2/preproc.resample.R;
    L = settings.resample.L;
    lpfilt = ldv_FIRlowpass(preproc.resample.R, L, fc, fsi, 'lowpass');
    %       fvtool(lpfilt.a);
end

% if this is the first segment we can build whitening filter
if preproc.whitening
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

