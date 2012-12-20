function [f, cxy, info] = ldv_coherence(method, x, y, params, xfs, yfs)

% LDV_COHERENCE compute coherence data.
%
% method = 'MSCOHERE',
% x      = input data vector
% fs     = sample rate of input data vector
% params = struct with fields 'scale', 'win', 'nfft', 'nolap'
%   where:
%       win   = 'Hanning', 'Bartlett', 'Flattop', 'none'
%       nfft  = number of points to put in each fft
%       nolap = fraction of overlap (0-1)
%
% M Hewitson 10-08-06
%
% $Id$
%

% check input vectors
[x, y, fs] = ldv_matchvectors(x, xfs, y, yfs);

switch method
  case 'MSCOHERE'

    % parameters
    nfft  = floor(params.nfft*fs);
    nolap = floor(nfft*params.nolap);

    % compute window
    win = ldv_getwindow(nfft, params.win);

    % compute power spectral density using pwelch
    [cxy, f] = mscohere(x, y, win, nolap, nfft, fs);

    % build info struct
    info.nfft  = nfft;
    info.nolap = params.nolap;
    info.navs  = floor((1.0*length(x)-nolap)/(nfft-nolap));
    
  otherwise
    error('### unknown spectrum method');
end



% END
