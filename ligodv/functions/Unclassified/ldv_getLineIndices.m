function idx = ldv_getLineIndices(nfft, f0, freqs, f, Nx)

% LDV_GETLINEINDICES return indices of line frequencies given the resolution
% of the data and any heterodynce offset.
% 
% M Hewitson 04-09-06
% 
% $Id$
% 


nf  = length(freqs);
idx = zeros(size(freqs));

for j=1:nf

  fp = abs(f-freqs(j));
  idx(j) = find(fp == min(fp));
end
  
% j = round(nfft*(f-f0)) + 1;
% idx = j(find(j<=Nx));


% END