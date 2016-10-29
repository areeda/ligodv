function nxx = ldv_nfest(xx, bw, ol)

% LDV_NFEST make a noise-floor estimate of an input spectrum.
% 
% M Hewitson 17-08-06
% 
% $Id$
% 

%  can use mnfest if it exists

if exist('mnfest') == 3

  %dv_disp('* using mnfest');
  nxx = [mnfest(xx, bw, ol)];
  
else
  
  N   = length(xx);
  nxx = [];

  for j=1:N

    % Determine the interval we are looking in
    hbw = floor(bw/2);
    interval = j-hbw:j+hbw;
    %   idx = find(interval<=0);
    interval(interval<=0)=1;
    %   idx = find(interval>N);
    interval(interval>N)=N;

    % calculate median value of interval
    % after throwing away outliers
    trial = sort(xx(interval));
    b = floor(ol*length(trial));
    nxx(j) = median(trial(1:b));

  end
end

% END