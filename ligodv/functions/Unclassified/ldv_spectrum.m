function [f, xx, xxmin, xxmax, info] = ldv_spectrum(method, x, params, fs)

% LDV_SPECTRUM compute a spectrum of the data.
%
% method = 'Welch',
% x      = input data vector
% fs     = sample rate of input data vector
% params = struct with fields 'scale', 'win', 'nfft', 'nolap'
%   where:
%       scale = 'ASD', 'AS', 'PSD', 'PS'
%       win   = 'Hanning', 'Bartlett', 'Flattop', 'none'
%       nfft  = number of points to put in each fft
%       nolap = fraction of overlap (0-1)
%
% M Hewitson 08-08-06
%
% $Id$
%

switch method
  case 'MPSD'
    
    % parameters
    nfft  = floor(params.nfft*fs);
    nolap = floor(nfft*params.nolap);

    % compute window
    win = ldv_getwindow(nfft, params.win);

    % compute power spectral density using pwelch
    [xx, xxmin, xxmax, f, info] = ldv_mpsd(x, win, nolap, nfft, fs, params.scale);
    
  case 'Welch'

    % parameters
    nfft  = floor(params.nfft*fs);
    nolap = floor(nfft*params.nolap);

    % compute window
    win = ldv_getwindow(nfft, params.win);

    % compute power spectral density using pwelch
    [pxx, f] = pwelch(x, win, nolap, nfft, fs);

    % scale units
    S1 = sum(win);
    S2 = sum(win.^2);
    enbw = fs * S2 / (S1*S1);
    switch params.scale
      case 'ASD'
        xx = sqrt(pxx);
      case 'AS'
        xx = sqrt(pxx) * sqrt(enbw);
      case 'PSD'
        xx = pxx;
      case 'PS'
        xx = pxx * enbw;
      otherwise
        error('### unknown spectral scaling.');
    end

    % build info struct
    info.nfft = nfft;
    info.enbw = enbw;
    info.nolap = params.nolap;
    info.navs = floor((1.0*length(x)-nolap)/(nfft-nolap));
    
  otherwise
    error('### unknown spectrum method');
end



% END
