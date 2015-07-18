function legendStr = ldv_buildlegend(obj, type)

% LDV_BUILDLEGEND build legend string from data object
%
% M Hewitson 08-08-06
%
% $Id$
%

% get settings
includingPrime = obj.data.includingPrime;

% set start and stop
if includingPrime > 0
    startgps = obj.startgps + includingPrime;
else
    startgps = obj.startgps;
end
stopgps  = obj.stopgps;
nsecs    = stopgps - startgps;

% additional info tag
switch obj.source.type
    case {'hour trends', 'day trends'}

    otherwise
        tag = '';
end

% build legend
switch type
    case 'timeseries'

        legendStr = sprintf('%02d: %s\nfs = %d : %ds from %s %s',...
            obj.id, strrep(strrep(obj.channel, '_', '\_'),'^','\^'),...
            obj.data.fs, nsecs, ...
            ldv_gps2utc(startgps), obj.comment);
        if obj.preproc.heterodyneOn
            legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
        end
        if ~strcmp(obj.preproc.math.cmd,'u')
            legendStr = [legendStr ' math: ' obj.preproc.math.cmd];
        end
        legendStr = cellstr(legendStr);
    case 'spectrum'

        legendStr = ( sprintf('%02d: %s\nfs = %d : %ds from %s, %s\nnfft=%d, nolap=%2.2f, enbw=%2.2g, navs=%d',...
            obj.id, strrep(strrep(obj.channel, '_', '\_'),'^','\^'),...
            obj.data.fs, nsecs, ...
            ldv_gps2utc(startgps), obj.comment, obj.info.nfft, obj.info.nolap, obj.info.enbw, obj.info.navs ));
        if obj.preproc.heterodyneOn
            legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
        end
        if ~strcmp(obj.preproc.math.cmd,'u')
            legendStr = [legendStr ', math: ' obj.preproc.math.cmd];
        end
        legendStr = cellstr(legendStr);
    case 'lpsd'

        legendStr = ( sprintf('%02d: %s\nfs = %d : %ds from %s - %s\nnfft=%d, nolap=%2.2f',...
            obj.id, strrep(strrep(obj.channel, '_', '\_'),'^','\^'),...
            obj.data.fs, nsecs, ...
            ldv_gps2utc(startgps), obj.comment, obj.info.nfft, obj.info.nolap));
        if obj.preproc.heterodyneOn
            legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
        end
        legendStr = cellstr(legendStr);
    case 'coherence'

        legendStr = ( sprintf('%02d: %s\nfs = %d : %ds from %s - %s\nnfft=%d, nolap=%2.2f,  navs=%d',...
            obj.id, strrep(strrep(obj.channel, '_', '\_'),'^','\^'),...
            obj.data.fs, nsecs, ...
            ldv_gps2utc(startgps), obj.comment, obj.info.nfft, obj.info.nolap, obj.info.navs ));
        if obj.preproc.heterodyneOn
            legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
        end
        if ~strcmp(obj.preproc.math.cmd,'u')
            legendStr = [legendStr ', math: ' obj.preproc.math.cmd];
        end
        legendStr = cellstr(legendStr);

    case 'XYscatter'

        legendStr = ( sprintf('%02d: %s\nfs = %d : %ds from %s - %s',...
            obj.id, strrep(strrep(obj.channel, '_', '\_'),'^','\^'),...
            obj.data.fs, nsecs, ...
            ldv_gps2utc(startgps), obj.comment));
        if obj.preproc.heterodyneOn
            legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
        end
        if ~strcmp(obj.preproc.math.cmd,'u')
            legendStr = [legendStr ' math: ' obj.preproc.math.cmd];
        end
        legendStr = cellstr(legendStr);

    case 'xcorr'

        legendStr = ( sprintf('%02d: %s\nfs = %d : %ds from %s - %s\nscaling: %s',...
            obj.id, strrep(strrep(obj.channel, '_', '\_'),'^','\^'),...
            obj.data.fs, nsecs, ...
            ldv_gps2utc(startgps), obj.comment, obj.info.scaleopt...
            ));
        if obj.preproc.heterodyneOn
            legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
        end
        if ~strcmp(obj.preproc.math.cmd,'u')
            legendStr = [legendStr ', math: ' obj.preproc.math.cmd];
        end
        legendStr = cellstr(legendStr);

    case 'histogram'

        legendStr = ( sprintf('%02d: %s\nfs = %d : %ds from %s \n\\mu=%2.3g, \\sigma=%2.3g %s',...
            obj.id, strrep(strrep(obj.channel, '_', '\_'),'^','\^'),...
            obj.data.fs, nsecs, ...
            ldv_gps2utc(startgps),...
            obj.info.mu, obj.info.std, obj.comment));
        if obj.preproc.heterodyneOn
            legendStr = [legendStr sprintf('\nhet @ %2.2f Hz', obj.preproc.f0)];
        end
        if ~strcmp(obj.preproc.math.cmd,'u')
            legendStr = [legendStr ', math: ' obj.preproc.math.cmd];
        end
        legendStr = cellstr(legendStr);
    otherwise
        error('### unknown legend type');
end


% END