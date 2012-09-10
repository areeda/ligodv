function [t, f, sxx, info] = ldv_spectrogram(method, x, params, fs)

% LDV_SPECTROGRAM compute a spectrogram of the data.
%
% method = 'Matlab',
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
  case 'Matlab'

    % parameters
    nfft  = floor(params.nfft*fs);
    nolap = floor(nfft*params.nolap);

    % compute window
    win  = ldv_getwindow(nfft, params.win);
    S1   = sum(win);
    S2   = sum(win.^2);
    enbw = fs * S2 / (S1*S1);

    % compute power spectral density using pwelch
    if exist('mSpecgram') == 3
      ldv_disp('*** using mSpecgram - you have chosen wisely.');
      [b, f, t] = mSpecgram(x, win, nolap, nfft, fs);
      sxx = abs(b) * sqrt(2 /(fs*S2));
      %sxx = imag(b);
      
    elseif exist('spectrogram') == 2
      
      ldv_disp('*** using spectrogram(), well ok, but mSpecgram is better.')
      [Sxx, f, t, pxx] = spectrogram(x, win, nolap, nfft, fs);
      sxx = sqrt(pxx);

    elseif exist('specgram') == 2
      warning('### you seem to have an old MATLAB. Upgrade!')
      warning('### I''ll carry on working for now...')
      ldv_disp('*** using specgram() - are you crazy?')
      [b,f,t] = specgram(x, nfft, fs, win, nolap);
      sxx = abs(b) * sqrt(2 /(fs*S2));

    else
      error('### no spectrogram function found');  
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
