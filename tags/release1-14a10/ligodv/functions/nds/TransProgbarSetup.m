%% Manage the progress bar for this transfer
function [progBar, tsec] = TransProgbarSetup( params, primeTime )
%TRANSPROGBARSETUP Create the Progress JBar and calculate what we have to do
%   Input:
%       params - A structure defining time intervals and channels to
%       transfer
%   Output:
%       progBar - the Java Progress bar object with much of the text set
%       tsec - total seconds of data to transfer.  Not as good as bytes but
%           we don't have sample rate and data type here, maybe later
    ntimes = params.times.ntimes;
    nchans = size(params.channels,1);
    chanList = '';
    tsec = 0;
    for time=1:ntimes
        for ch=1:nchans
            channel = params.channels(ch,:);
            channel = strtrim(channel);
            if (~isempty(chanList))
                chanList = [chanList ', '];
            end
            chanList = [chanList channel];
            
            startgps = params.times.t(time).startgps-primeTime;
            stopgps  = params.times.t(time).stopgps;
            tsec = tsec + stopgps - startgps;
        end
    end
    progBar = ldvjutils.Progress();
    
    progBar.setProgress(-1);
    % Top text line is what we're doing

    winTitle = ['Transferring data from ', params.server];
    progBar.setTitle(winTitle); % this is window title
    whatWereDoing = sprintf('Getting %d channel(s) at %d time interval(s)',nchans,ntimes);
    progBar.setTitleLbl(whatWereDoing);
    
    if (length(chanList) > 60)
        chanList = [chanList(1:60) '...'];
    end
    progBar.setChanName(chanList);
    transProgSetTime(1, ntimes, params.times.t(1),progBar);
    transProgSetProg(-1,tsec,progBar);
end
%% Set time interval
function transProgSetTime(time,chan,interval,progBar)
% input:
%   time - time interval number (1-n)
%   chan - chan # (1-n)
%   inteval - interval descriptor
%   progBar - the object
    sec = interval.stopgps - interval.startgps;
    utc = ldv_gps2utc(interval.startgps);
    txt = sprintf('Interval %d of %d: %s (%d)',chan,time,utc,sec);
    progBar.setWorkingOn(txt);
end
%% Set the progress in text and on the bar
function transProgSetProg(cur, tot,progBar)
    if (cur >=0)
        txt = sprintf('Transfering second %d of %d',cur,tot);
    else
        txt = sprintf('Transfering %d seconds of data',tot);
    end
    progBar.setEstTime(txt);
    pct=-1;
    if (tot > 0 && cur > 0)
        pct = cur*100/tot;
    end
    progBar.setProgress(pct);
end