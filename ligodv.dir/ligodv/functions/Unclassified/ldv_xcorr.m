function [lags, cxy, info] = ldv_xcorr(method, x, y, scaleopt, fs);

% LDV_XCORR compute cross-correlation of data.
%
% method = 'XCORR',
% x      = input data vector
% y      = input data vector
% fs     = sample rate of input data vector
%
% M Hewitson 17-08-06
%
% $Id$
%

nx = length(x);
ny = length(y);


switch method
  case 'XCORR'

    if isempty(y)
      % autocorrelation
      [cxy, lags] = xcorr(x, scaleopt);
    else
      % xcorrelation
      [cxy, lags] = xcorr(x, y, scaleopt);
    end
    
    info.scaleopt = scaleopt;
    
  otherwise
    error('### unknown cross-correlation method');
end

lags = lags/fs;


% END
