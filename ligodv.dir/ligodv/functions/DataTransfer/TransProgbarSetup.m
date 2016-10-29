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
    % it seems the list of channels can be a string array or a cell array,
    % I haven't quite figured out why so we'll handle both.
    if (iscell(params.channels))
        nchans = size(params.channels,2);
    else
        nchans = size(params.channels,1);
    end
    chanList = '';
    pchan=params.channels;
    tsec = 0;
    for time=1:ntimes
        for ch=1:nchans
            if (iscell(pchan))
                channel = pchan{ch};
            else
                channel = pchan(ch,:);
            end
            if (~isempty(channel))
                % I don't know how an empty channel name gets in that list
                % but we'll ignore it here
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
    
    transProgSetProg(-1,tsec,progBar);
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