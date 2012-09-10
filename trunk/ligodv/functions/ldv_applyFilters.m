function xo = ldv_applyFilters(obj, x)

% LDV_APPLYFILTERS apply the data object's filters to the data.
% 
% 
% M Hewitson 09-08-06
% 
% $Id$
% 


xo = x;

% Should we apply filters?
if obj.filters.apply == 1

    % loop through filters
    nfilts = obj.filters.nfilts;
    for ft=1:nfilts
        % get this filter
        filt = obj.filters.filts(ft).filt;

        ldv_disp('+ applying %s to %s', filt.name, obj.channel);

        if strcmp(filt.name,'pzmodel')
            % filter pz model data
            [xo] = filter(filt.a, filt.b, xo);
        else
            % filter standard types data
            Zi       = filt.histout;
            [xo, Zf] = filter(filt.a, filt.b, xo, Zi);
            filt.histout = Zf;
        end
    end
end



% END