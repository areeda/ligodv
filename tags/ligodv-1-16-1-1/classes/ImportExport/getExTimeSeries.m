function [ ts, varargout] = getExTimeSeries( obj,n )
%getExTimeSeries - get a Matlab Time Series object from exported Ligodv
%data
%   See
%   http://www.mathworks.com/help/matlab/data_analysis/time-series-objects.html
%   for more information.
%   A time series is a convenient way to plot the data and perform certain
%   functions like interpolation, resampling ...

    % try to give some meaningful error messages
    ermsg = '';
    if (~isstruct(obj))
        ermsg = 'First agrument must be an ex_objs structure';
    elseif (~ isfield(obj,'nobjs') || obj.nobjs < 1)
        ermsg = 'not a valid export object';
    elseif (n < obj.nobjs)
        ermsg = 'invalid object number';
    else
        o = obj.objs(n);
        do = DataObject;
        do.initFromObj(o);
        chName = do.getChanName();
        ts = do.getTimeSeries();
        if (nargout > 1)
            varargout{1} = chName;
        end

    end
    if (~isempty(ermsg))
        error(ermsg);
    end

end

