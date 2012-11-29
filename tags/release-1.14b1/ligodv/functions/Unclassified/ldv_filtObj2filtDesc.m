function filters = ldv_filtObj2filtDesc(fobjs)

% LDV_FILTOBJ2FILTDESC convert filter objects to filter descriptions.
%
% M Hewitson 09-08-06
%
% $Id$
%

% init filter descriptions
filters.filts  = [];
filters.nfilts = 0;

% loop over filter objects
for f = 1:fobjs.nfilts

    % this filter object
%     filt  = fobjs.filts(f).filt;
    fdesc = fobjs.filts(f).fdesc;

    if strcmp(fdesc.type,'highpass') || strcmp(fdesc.type,'lowpass') ||...
            strcmp(fdesc.type,'bandpass') || strcmp(fdesc.type,'bandreject')
        filters.nfilts = filters.nfilts + 1;
        filters.filt(filters.nfilts).type  = fdesc.type;
        filters.filt(filters.nfilts).f     = fdesc.f;
        filters.filt(filters.nfilts).order = fdesc.order;
        filters.filt(filters.nfilts).gain  = fdesc.gain;
    elseif strcmp(fdesc.type,'pzmodel')
        filters.nfilts = filters.nfilts + 1;
        filters.filt(filters.nfilts).type  = fdesc.type;
        filters.filt(filters.nfilts).npoles = fdesc.npoles;
        filters.filt(filters.nfilts).nzeros = fdesc.nzeros;
        filters.filt(filters.nfilts).poles = fdesc.poles;
        filters.filt(filters.nfilts).zeros = fdesc.zeros;
        filters.filt(filters.nfilts).gain  = fdesc.gain;
    else
        error('Unknown filter type.')
    end

end



% END