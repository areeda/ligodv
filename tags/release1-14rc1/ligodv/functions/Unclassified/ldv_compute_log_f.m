function [f,r,m, L] = ldv_compute_log_f(fs, N, Kdes, Kmin, Jdes, olap)


% LDV_COMPUTE_LOG_F compute the frequency and resolution vectors for
% use with log frequency smoothing.
% 
% 
% M Hewitson 07-03-06
% 

% Settings
fmin = fs/N;
fmax = fs/2;
j    = 1;
f(j) = fmin;

% Initialise constants
rav  = fs/N*(1+(1-olap)*(Kdes-1));
rmin = fs/N*(1+(1-olap)*(Kmin-1));
g    = log(fmax)-log(fmin);

% compute f(j)
while f < fmax
  % compute r'(j)
  rr(j) = f(j)*g/(Jdes-1);
  % compute r''(j)
  if rr(j) >= rav
    rrr(j) = rr(j);
  else
    rrr(j) = sqrt(rav*rr(j));
  end

  % if this is below the lower possible resolution
  if rrr(j) <= rmin
    rrr(j) = rmin;
  end

  % compute L(j)
  L(j) = round(fs/rrr(j));

  % compute freq res
  r(j) = fs/L(j);
  m(j) = f(j)/r(j);

  tf = f(j) + r(j);
  if tf<fmax
    f(j+1) = tf;
    j = j + 1;
  else
    break
  end
end


