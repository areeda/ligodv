function [t, x, info] = ldv_preparedata(obj, handles)

% LDV_PREPAREDATA prepares a data vector given the data object. Does
% filtering, prime data removal, time-offset removal, etc.
%
% M Hewitson 10-08-06
%
% $Id$
%

% deal with prime data
if obj.data.includingPrime > 0
    t0  = obj.startgps + obj.data.includingPrime;
else
    t0  = obj.startgps;
end

% set data
obj
x     = obj.data.x;
fs    = obj.data.fs;


% apply any filters
xo = ldv_applyFilters(obj, x);

% remove prime data
if obj.data.includingPrime > 0
    x = xo(obj.data.includingPrime*fs+1:end);
else
    x = xo;
end

% find nsecs after prime data removal
nsecs = length(x)/fs;

% check for heterodyning
if obj.preproc.heterodyneOn
    f0 = obj.preproc.f0;
else
    f0 = 0;
end

% grow time vector
Nx = length(x);
t  = linspace(0, nsecs-1/fs, Nx);

% apply data select
dsStr = get(handles.plotDataSelect, 'String');
if isempty(dsStr) || strcmp(dsStr, '0:end')
    t1 = 0;
    t2 = Nx/obj.data.fs;
else
    [tk,r] = strtok(dsStr, ':');
    t1 = str2double(deblank(tk));
    t2str = deblank(r(2:end));
    if strcmp(t2str, 'end')
        t2 = Nx/obj.data.fs;
    else
        t2 = str2double(t2str);
    end
    cmd = sprintf('idx = (round([1+%f*%d:1+%f*%d]));', t1, fs, t2, fs);
    eval(cmd);
    idx = idx(idx>0 & idx<=Nx);
    cmd = sprintf('t = t(idx);');
    eval(cmd);
    cmd = sprintf('x = x(idx);');
    eval(cmd);
end

% info structure
info.t0      = t0;
info.fs      = fs;
info.channel = obj.channel;
info.f0      = f0;


% END