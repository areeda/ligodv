function [Sxx, Smin, Smax, f, info] = ldv_mpsd(x, win, nolap, nfft, fs, scale)

% LDV_MPSD a psd estimation based on pwelch from MATLAB. The difference is that
% linear detrending is done on each windowed data segment.
% 
% function [f, pxx, info] = mpsd(x, win, nfft, nolap, fs)
% 
% Inputs:
%     x      - data vector
%     win    - a window function
%              Specify a vector of window samples or a length. If a length
%              is specified, a Hamming window is used.
%     nfft   - number of samples per fft
%     nolap  - number of samples to overlap each segment by
%     fs     - sample rate of input time-series
%     scale  - specify one of 'ASD', 'AS', 'PSD', 'PS'
% 
% Outputs:
%     f      - a frequency vector 
%     Sxx    - spectral estimate in units specified by 'scale'
%     info   - a structure of information
% 
% NOTE: segment_info() is copied directly from MATLAB's welshparse.m.
% 
% M Hewitson 25-09-06
% 
% $Id$
% 


disp(sprintf('**-- calling mpsd --**'));

% get segment information
Nx = length(x);
[L,noverlap,win,msg] = segment_info(Nx,win,nolap);

% Compute the number of segments
k = (Nx-noverlap)./(L-noverlap);

% Uncomment the following line to produce a warning each time the data
% segmentation does not produce an integer number of segements.
if fix(k) ~= k
   warning('The number of segments is not an integer, truncating data.');
end
k = fix(k);

% fix vectors
x   = x(:);
win = win(:);

% Initialise the spectral estimates
Sxx  = zeros(nfft,1);
Smin = 1e10*ones(nfft,1);
Smax = zeros(nfft,1);
mu   = zeros(nfft,1);
sig  = zeros(nfft,1);

% loop over segments
LminusOverlap = L-noverlap;
xStart = 1:LminusOverlap:k*LminusOverlap;
xEnd   = xStart+L-1;

for i = 1:k,
  %disp(sprintf('* computing segment %d', i));
  % data segment, detrend and window
  dseg = detrend(x(xStart(i):xEnd(i))) .* win;
  %dseg = (x(xStart(i):xEnd(i))) .* win;
  
  % compute fft
  xx   = fft(dseg,nfft);  
  Sxx = ((Sxx .* (i-1)) +  xx.*conj(xx)) ./ i;
  
  % compute running mean and variance per freq bin
  delta = Sxx - mu;
  mu    = mu + delta/(i+1);
  sig   = sig + delta.*(Sxx - mu);
  
%   Smax = [max([Smax.' ; Sxx.'])].';
%   Smin = [min([Smin.' ; Sxx.'])].';
end

sig = sig / (i-1);

Smax = Sxx + sqrt(sig);
Smin = Sxx - sqrt(sig);

% take only one-sided
Sxx  = Sxx(1:nfft/2+1);
Smin = Smin(1:nfft/2+1);
Smax = Smax(1:nfft/2+1);


% scale the data as required
[Sxx, info]  = scale_xx(Sxx, win, fs, scale);
[Smin, info] = scale_xx(Smin, win, fs, scale);
[Smax, info] = scale_xx(Smax, win, fs, scale);

% grow frequency vector
f = [linspace(0, fs/2, length(Sxx))].';

% complete info
info.nsecs = Nx/fs;
info.navs  = k;
info.nolap = noverlap/fs;

%-----------------------------------------------------------------------------------------------
function [yy, info] = scale_xx(xx, win, fs, norm)

nfft = length(win);
S1   = sum(win);
S2   = sum(win.^2);
enbw = fs * S2 / (S1*S1);

switch norm
  case 'ASD'
    yy = sqrt(xx) * sqrt(2 / (fs*S2));
  case 'PSD'
    yy = xx * 2 /(fs*S2);
  case 'AS'
    yy = sqrt(xx) * sqrt(2) / S1;
  case 'PS'
    yy = xx * 2 / (S1^2);
  case 'none'
    yy = xx;
  otherwise
    error('Unknown normalisation');
end

info.nfft = nfft;
info.enbw = enbw;
info.norm = norm;

%-----------------------------------------------------------------------------------------------
function [L,noverlap,win,msg] = segment_info(M,win,noverlap)
%SEGMENT_INFO   Determine the information necessary to segment the input data.
%
%   Inputs:
%      M        - An integer containing the length of the data to be segmented
%      WIN      - A scalar or vector containing the length of the window or the window respectively
%                 (Note that the length of the window determines the length of the segments)
%      NOVERLAP - An integer containing the number of samples to overlap (may be empty)
%
%   Outputs:
%      L        - An integer containing the length of the segments
%      NOVERLAP - An integer containing the number of samples to overlap
%      WIN      - A vector containing the window to be applied to each section
%      MSG      - A string containing possible error messages
%
%
%   The key to this function is the following equation:
%
%      K = (M-NOVERLAP)/(L-NOVERLAP)
%
%   where
%
%      K        - Number of segments
%      M        - Length of the input data X
%      NOVERLAP - Desired overlap
%      L        - Length of the segments
%
%   The segmentation of X is based on the fact that we always know M and two of the set
%   {K,NOVERLAP,L}, hence determining the unknown quantity is trivial from the above
%   formula.

% Initialize outputs
L = [];
msg = '';

% Check that noverlap is a scalar
if any(size(noverlap) > 1),
    msg.identifier = generatemsgid('invalidNoverlap');
    msg.message = 'You must specify an integer number of samples to overlap.';
    return;
end

if isempty(win),
    % Use 8 sections, determine their length
    if isempty(noverlap),
        % Use 50% overlap
        L = fix(M./4.5);
        noverlap = fix(0.5.*L);
    else
        L = fix((M+7.*noverlap)./8);
    end
    % Use a default window
    win = hamming(L);
else
    % Determine the window and its length (equal to the length of the segments)
    if ~any(size(win) <= 1) | ischar(win),
        msg.identifier = generatemsgid('invalidWindow');
        msg.message = 'The WINDOW argument must be a vector or a scalar.';
        return
    elseif length(win) > 1,
        % WIN is a vector
        L = length(win);
    elseif length(win) == 1,
        L = win;
        win = hamming(win);
    end
    if isempty(noverlap),
        % Use 50% overlap
        noverlap = fix(0.5.*L);
    end
end

% Do some argument validation
if L > M,
    msg.identifier = generatemsgid('invalidSegmentLength');
    msg.message = 'The length of the segments cannot be greater than the length of the input signal.';
    return;
end

if noverlap >= L,
    msg.identifier = generatemsgid('invalidNoverlap');
    msg.message = 'The number of samples to overlap must be less than the length of the segments.';
    return;
end

%-----------------------------------------------------------------------------------------------

% END