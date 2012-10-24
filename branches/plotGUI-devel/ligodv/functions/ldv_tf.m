function [f, Txy, info] = ldv_tf(method, x, y, params, xfs, yfs)

% LDV_TF compute transfer function of data.
%
% method = 'TFESTIMATE',
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
  case 'TFESTIMATE'

    % parameters
    nfft  = floor(params.nfft*fs);
    nolap = floor(nfft*params.nolap);

    % compute window
    win = ldv_getwindow(nfft, params.win);
    
    if params.cpsd
      % compute cross-psd using pwelch
      [Txy, f] = cpsd(x, y, win, nolap, nfft, fs);
    else
      % compute transfer function using pwelch
      [Txy, f] = tfestimate(x, y, win, nolap, nfft, fs);
    end
    
    % build info struct
    info.nfft  = nfft;
    info.nolap = params.nolap;
    info.navs  = floor((1.0*length(x)-nolap)/(nfft-nolap));
    
  otherwise
    error('### unknown spectrum method');
end


% END
