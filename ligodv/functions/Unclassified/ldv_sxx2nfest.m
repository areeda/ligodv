function nxx = ldv_sxx2nfest(sxx, bw, ol)

% LDV_SXX2NFEST make a noise floor estimate of each column of sxx. If sxx is
% complex then the noise floor is computed for both magnitude and phase and
% then recombined to return a complex nxx.
% 
% The shape of sxx is assumed to be [freq x time].
% 
% M Hewitson 13-12-06
% 
% $Id$
% 


if ~any(imag(sxx(:)))
  
  ldv_disp('*** got real matrix')
  nt = size(sxx,2);
  nxx = zeros(size(sxx));
  for t=1:nt
%     dv_disp('   + processed %d of %d', t, nt);
    nxx(:,t) = ldv_nfest(sxx(:,t), bw, ol);
  end
  
  
else
  
  ldv_disp('*** got complex matrix')
  
  m = abs(sxx);
  p = phase(sxx);
  nt = size(sxx,2);
  nxx = zeros(size(sxx));
  for t=1:nt
    nxm = ldv_nfest(m(:,t), bw, ol);
    nxp = ldv_nfest(p(:,t), bw, ol);
    nxx(:,t) = nxm.exp(1i.*nxp*pi/180);
  end
  
end

% END