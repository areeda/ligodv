function rms = ldv_spec_rms(f, sxx)

% LDV_SPEC_RMS compute rms deviation from a spectrum.
% 
% 
% M Hewitson 23-11-06
% 
% $Id$
% 


ldv_disp(['!!! RMS computation from a spectrum only makes sense\n'...
          'if the spectrum is expressed as an amplitude spectral density.']);

rms = zeros(size(sxx));
n   = length(sxx);
ps  = sxx.^2;

for j=n-1:-1:1
  rms(j) = rms(j+1) + (ps(j+1) + ps(j))*(f(j+1)-f(j))/2;
end

rms = sqrt(rms);

%% Maybe we don't need this and assume that the user is sensible.
% Rescale to amplitude spectrum
% This works with an amplitude spectral density so the input is rescaled
% according to what the scale of the input spectrum is and the enbw.
% switch scale
%   case 'ASD'
%     axx = sqrt(sxx.^2 .* enbw);
%   case 'AS'
%     axx = sxx;
%   case 'PSD'
%     axx = sqrt(sxx.*enbw);
%   case 'PS'
%     axx = sqrt(sxx);
%   otherwise
%     error('### unknown spectral scaling.');
% end


% END