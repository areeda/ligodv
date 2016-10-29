function [lines, nf] = ldv_linedetect(f, axx, N, fsearch, thresh, bw, hc)

% LDV_LINEDETECT find spectral lines in the data x.
% 
% function lines = ldv_linedetect(f, axx, N, fsearch, thresh, bw, hc)
% 
% f        - frequency vector
% axx      - spectral density
% N        - max number of lines to return
% fsearch  - freqeuncy search interval
% thresh   - a threshold to test normalised AS against
% bw       - bandwidth over which to compute median
% hc       - percent of outliers to exclude from median estimation [0-1]
% 
% returns:
%   lines - array of structures of detected lines with
%           lines(n).idx  - index into f,ax,nf
%           lines(n).f;   - frequency of line
%           lines(n).a;   - amplitude of line
% 
% M Hewitson 31-08-06
% 
% $Id$
% 


ldv_disp('   + detecting lines...');

%% spectral analysis

% make noise floor estimate
% bw = 16;
% hc = 0.8;
nf = ldv_nfest(axx, bw, hc);

% normalise power spectral density by noise floor estimate
naxx = axx./nf.';
% 
% figure
% loglog(f, axx, f, naxx)

%% look for spectral lines
l       = 0;
pmax    = 0;
pmaxi   = 0;
line    = [];
idx     = find( f>=fsearch(1) & f<=fsearch(2) );
for j=1:length(idx)
  v = naxx(idx(j));
  if v > thresh
    if v > pmax
      pmax  = v;
      pmaxi = idx(j);
    end
  else
    if pmax > 0      
      % find index when we have pmax
      fidx = pmaxi; %(find(naxx(1:idx(j))==pmax));
      l = l+1;
      line(l).idx = fidx;
      line(l).f   = f(fidx);
      line(l).a   = axx(fidx);
    end
    pmax = 0;
  end  
end


%% Select largest peaks
lines = [];
if ~isempty(line)
  [bl, lidx] = sort([line.a], 'descend');
  lidxs = lidx(1:min([N length(lidx)]));
  lines = line(lidxs);
  ldv_disp('   + found %d lines.', length([lines.f]));
else
  ldv_disp('   + found 0 lines.');
end


% END
