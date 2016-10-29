function [varargout] = ldv_iirfiltresp(varargin)

% LDV_IIRFILTRESP Make a frequency response of the filter.
% 
% The input filter should be of the type 
% used in mfilter.
% 
% usage: [fd, mag, phase] = ldv_iirfiltresp(f1, f2, ndata, infilt)
%              [fd, resp] = ldv_iirfiltresp(f1, f2, ndata, infilt);
%              [fd, resp] = ldv_iirfiltresp(freq, infilt);
%                           ldv_iirfiltresp(freq, infilt);
% 
% inputs:
%   f1      -  the start frequency
%   f2      -  the stop frequency
%   ndata   -  number of evaluation points
%   infilt  -  an array mfilter type filter
%   freq    -  a vector of frequency values
% 
% outputs:
%   fd      -  an array of frequency vectors
%   mag     -  an array of magnitude responses (dB)
%   phase   -  an array of phase responses (degrees)
%   resp    -  complex response
% 
% The response is calculated as:
% 
%                          a0 + a1*exp(s/fs) + ... + an*exp((n-1)s/fs)
%          H(s) = gain * ---------------------------------------------
%                          b0 + b1*exp(s/fs) + ... + bm*exp((m-1)s/fs)
% 
% With no output variables, a plot of each filter will be generated.
% 
% M Hewitson 09-08-06 (copied from mfiltresp.m)
%
% 
% $Id$
%


if (nargin == 4)
  f1 = varargin{1};
  f2 = varargin{2};
  ndata = varargin{3};
  infilt = varargin{4};
  f = linspace(f1, f2, ndata);
  f = f(:);
  w = [2*pi.*f].';
  s = -i.*w;
  
  
elseif (nargin == 3 || nargin == 2)
  f = varargin{1};
  f = f(:);
  infilt = varargin{2};
  ndata = length(f);
  w = [2*pi.*f].';
  s = -i.*w; 
  if (nargin == 3) 
      titleTxt = varargin{3};
  else
      titleTxt = '';
  end
else
  error('incorrect input arguments');
end


nfil = length(infilt);
fd = [];

% loop through input filters
for fil = 1:nfil
  
	fd(fil,:) = squeeze(f);
	
	num = zeros(1, ndata);
	for n=1:length(infilt(fil).a)
      num = num + infilt(fil).a(n).*exp(s.*(n-1)/infilt(fil).fs);   
	end
	denom = zeros(1, ndata);
	for n=1:length(infilt(fil).b)
      denom = denom + infilt(fil).b(n).*exp(s.*(n-1)/infilt(fil).fs);   
	end
	
	dresp = num ./ denom;
	dresp = dresp .* infilt(fil).gain;  % apply the gain
	
  % fix for log10(0)
  dresp(dresp==0) = 1e-30;
  
	mag(fil,:) = 20*log10(abs(dresp));
	phase(fil,:) = angle(dresp)*180/pi;
	
	if(nargout == 0)
        ldv_disp('* plotting %s', infilt(fil).name);
		figure;
		subplot(2,1,1)
		semilogx(f, 20*log10(abs(dresp)), 'LineWidth', 2);
		legend('IIR response');
        title([titleTxt]);
		ylabel('Amplitude [dB]');
        grid;
		subplot(2,1,2);
		semilogx(f, (angle(dresp)*180/pi), 'LineWidth', 2);
		ylabel('Phase [Degrees]');
		xlabel('Frequency [Hz]');
    grid;
  end
end

if(nargout == 2)
  % complex
  varargout{1} = fd;
  varargout{2} = dresp; 
elseif (nargout == 3)
  varargout{1} = fd;
  varargout{2} = mag;
  varargout{3} = phase;
elseif (nargout == 0)
%   do nothing
else
  error('incorrect output arguments');  
end


