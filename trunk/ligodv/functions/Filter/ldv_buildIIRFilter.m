function fobj = ldv_buildIIRFilter(filt, fs)

% LDV_BUILDIIRFILTER build an IIR filter from the description and sample
% rate.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

switch filt.type
    case 'lowpass'
        fobj = ldv_lowpass(filt.gain, fs, filt.order, filt.f(1));
    case 'highpass'
        fobj = ldv_highpass(filt.gain, fs, filt.order, filt.f(1));
    case 'bandpass'
        fobj = ldv_bandpass(filt.gain, fs, filt.order, 0.5, filt.f);
    case 'bandreject'
        fobj = ldv_bandreject(filt.gain, fs, filt.order, 0.5, filt.f);
    case 'pzmodel'
        fobj = ldv_pzmodel(filt,fs);
    otherwise
        error('### unknown filter type');
end



% END