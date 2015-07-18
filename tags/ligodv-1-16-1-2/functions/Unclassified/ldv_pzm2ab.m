function [ao,bo] = ldv_pzm2ab(pzm, fs)
% LDV_PZM2AB convert pzmodel to IIR filter coefficients using bilinear
% transform.
% 
% usage: [a,b] = ldv_pzm2ab(pzm, fs)
% 
% M Hewitson 03-04-07
% 
% $Id$
% 

disp(sprintf('$$$ converting %s', pzm.type))

gain  = pzm.gain;
poles = pzm.poles;
zeros = pzm.zeros;
np = length(poles);
nz = length(zeros);

ao = [];
bo = [];

% First we should do complex pole/zero pairs
cpoles = [];
for j=1:np
  if poles(j).q > 0.5
    cpoles = [cpoles poles(j)];
  end
end
czeros = [];
for j=1:nz
  if zeros(j).q > 0.5
    czeros = [czeros zeros(j)];
  end
end

czi = 1;
for j=1:length(cpoles)
  if czi <= length(czeros)
    % we have a pair
    p = cpoles(j);
    z = czeros(czi);
    
    [ai,bi] = cpolezero(p.f, p.q, z.f, z.q, fs);
    if ~isempty(ao)>0
      [ao,bo] = ldv_abcascade(ao,bo,ai,bi);
    else
      ao = ai;
      bo = bi;
    end
    
    % increment zero counter
    czi = czi + 1;
  end
end

if length(cpoles) > length(czeros)
  % do remaining cpoles
  for j=length(czeros)+1:length(cpoles)
    disp('$$$ computing complex pole');
    [ai,bi] = cp2iir(cpoles(j), fs);
    if ~isempty(ao)>0
      [ao,bo] = ldv_abcascade(ao,bo,ai,bi);
    else
      ao = ai;
      bo = bi;
    end
  end
else
  % do remaining czeros
  for j=length(cpoles)+1:length(czeros)
    disp('$$$ computing complex zero');
    [ai,bi] = cz2iir(czeros(j), fs);
    if ~isempty(ao)>0
      [ao,bo] = ldv_abcascade(ao,bo,ai,bi);
    else
      ao = ai;
      bo = bi;
    end
  end
end
  
% Now do the real poles and zeros
for j=1:np
  pole = poles(j);
  if isnan(pole.q) || pole.q < 0.5
    disp('$$$ computing real pole');
    [ai,bi] = rp2iir(pole, fs);
    if ~isempty(ao)>0
      [ao,bo] = ldv_abcascade(ao,bo,ai,bi);
    else
      ao = ai;
      bo = bi;
    end
  end
end

for j=1:nz
  zero = zeros(j);
  if isnan(zero.q) || zero.q < 0.5
    disp('$$$ computing real zero');
    [ai,bi] = rz2iir(zero, fs);
    if ~isempty(ao)>0
      [ao,bo] = ldv_abcascade(ao,bo,ai,bi);
    else
      ao = ai;
      bo = bi;
    end
  end
end

% ao = ao.*gain; % Not needed, the gain is applied at a later point

% Old version that did everything individually - not so good.
% for j=1:np
%   pole = poles(j);
%   if get(pole, 'q') > 0.5
%     [ai,bi] = cp2iir(pole, fs);
%   else
%     [ai,bi] = rp2iir(pole, fs);
%   end
%   if ~isempty(ao)>0
%     [ao,bo] = ldv_abcascade(ao,bo,ai,bi);
%   else
%     ao = ai;
%     bo = bi;
%   end
% end
% 
% for j=1:nz
%   zero = zeros(j);
%   if get(zeros, 'q') > 0.5
%     [ai,bi] = cz2iir(zero, fs);
%   else
%     [ai,bi] = rz2iir(zero, fs);
%   end
%   if ~isempty(ao)>0
%     [ao,bo] = ldv_abcascade(ao,bo,ai,bi);
%   else
%     ao = ai;
%     bo = bi;
%   end
% end
%
% ao = ao.*gain; 

%% Begin all the additional functions - break out into seperate files later

function [a,b] = cpolezero(pf, pq, zf, zq, fs)
% 
% Return IIR filter coefficients for a complex pole
% and complex zero designed using the bilinear transform.
% 
% usage: [a,b] = cpolezero(pf, pq, zf, zq, fs)
% 
% 
%  M Hewitson 2003-02-18
% 

disp('$$$ computing complex pole/zero pair');

wp = pf*2*pi;
wp2 = wp^2;
wz = zf*2*pi;
wz2 = wz^2;

k = 4*fs*fs + 2*wp*fs/pq + wp2;

a(1) = (4*fs*fs + 2*wz*fs/zq + wz2)/k;
a(2) = (2*wz2 - 8*fs*fs)/k;
a(3) = (4*fs*fs - 2*wz*fs/zq + wz2)/k;
b(1) = 1;
b(2) = (2*wp2 - 8*fs*fs)/k;
b(3) = (wp2 + 4*fs*fs - 2*wp*fs/pq)/k;

% normalise dc gain to 1
g = iirdcgain(a,b);
a = a / g;


function g = iirdcgain(a,b)

% Work out the DC gain of an IIR
% filter given the coefficients.
% 
% usage:
%   g = iirdcgain(a,b)
%   
% inputs:
%   a - numerator coefficients
%   b - denominator coefficients
%   
% outputs:
%   g - gain
%   
% M Hewitson 03-07-02
% 
%
% $Id$
%

g = 0;

suma = sum(a);
if(length(b)>1)
  sumb = sum(b);
  g = suma / sumb;
else
  g = suma;
end

function [a,b] = rp2iir(p, fs)
% RP2IIR Return a,b coefficients for a real pole designed using the bilinear transform.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DESCRIPTION: RP2IIR Return a,b coefficients for a real pole designed using
%              the bilinear transform.
%
% CALL:        filt = rpole(p, fs)
%
% REMARK:      This is just a helper function. This function should only be
%              called from class functions.
%
% INPUT:       p  - pole object
%              fs - the sample rate for the filter
%
% VERSION:     $Id$
%
% HISTORY:     03-03-07 M Hewitson
%                 Creation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VERSION  = '$Id$';
CATEGORY = 'Internal';

%%%%%   'Params' && 'Version' Call   %%%%%
if nargin == 2
  if isa(p, 'pole') && ischar(fs)
    in = fs;
    if strcmp(in, 'Params')
      a = plist();
      return
    elseif strcmp(in, 'Version')
      a = VERSION;
      return
    elseif strcmp(in, 'Category')
      a = CATEGORY;
      return
    end
  end
end

f0 = p.f;
w0 = f0*2*pi;
a(1) = w0 / (2*fs + w0);
a(2) = a(1);
b(1) = 1;
b(2) = (w0-2*fs) / (w0+2*fs);

function [a,b] = rz2iir(z, fs)
% RZ2IIR Return a,b IIR filter coefficients for a real zero designed using the bilinear transform.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DESCRIPTION: RZ2IIR Return a,b IIR filter coefficients for a real zero
%              designed using the bilinear transform.
%
% CALL:        [a,b] = rz2iir(z, fs)
%
% REMARK:      This is just a helper function. This function should only be
%              called from class functions.
%
% INPUT:       z  - zero object
%              fs - the sample rate for the filter
%
% VERSION:     $Id$
%
% HISTORY:     18-02-2003 Hewitson
%                 Creation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VERSION  = '$Id$';
CATEGORY = 'Internal';

%%%%%   'Params' && 'Version' Call   %%%%%
if nargin == 2
  if isa(z, 'zero') && ischar(fs)
    in = fs;
    if strcmp(in, 'Params')
      a = plist();
      return
    elseif strcmp(in, 'Version')
      a = VERSION;
      return
    elseif strcmp(in, 'Category')
      a = CATEGORY;
      return
    end
  end
end

f0 = z.f;
w0 = f0*2*pi;

a(1) = (2*fs + w0) / w0;
a(2) = (-2*fs + w0) / w0;

b(1) = 1;
b(2) = 1;

function [a,b] = cp2iir(p, fs)
% CP2IIR Return a,b IIR filter coefficients for a complex pole designed using the bilinear transform.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DESCRIPTION: CP2IIR Return a,b IIR filter coefficients for a complex pole
%              designed using the bilinear transform.
%
% CALL:        [a,b] = cp2iir(p, fs)
%
% REMARK:      This is just a helper function. This function should only be
%              called from class functions.
%
% INPUT:       p  - pole object
%              fs - the sample rate for the filter
%
% VERSION:     $Id$
%
% HISTORY:     03-04-2007 M Hewitson
%                  Creation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VERSION  = '$Id$';
CATEGORY = 'Internal';

%%%%%   'Params' && 'Version' Call   %%%%%
if nargin == 2
  if isa(p, 'pole') && ischar(fs)
    in = fs;
    if strcmp(in, 'Params')
      a = plist();
      return
    elseif strcmp(in, 'Version')
      a = VERSION;
      return
    elseif strcmp(in, 'Category')
      a = CATEGORY;
      return
    end
  end
end

f0 = p.f;
q  = p.q;

w0  = f0*2*pi;
w02 = w0^2;

k    = (q*w02 + 4*q*fs*fs + 2*w0*fs) / (q*w02);
b(1) =  1;
b(2) = (2*w02-8*fs*fs) / (k*w02);
b(3) = (q*w02 + 4*q*fs*fs - 2*w0*fs) / (k*q*w02);

a(1) =  1/k;
a(2) = -2/k;
a(3) = -1/k;
a    =  a*-2;

% END

function [a,b] = cz2iir(z, fs)
% CZ2IIR return a,b IIR filter coefficients for a complex zero designed using the bilinear transform.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DESCRIPTION: CZ2IIR return a,b IIR filter coefficients for a complex zero
%              designed using the bilinear transform.
%
% CALL:        [a,b] = cz2iir(z, fs)
%
% REMARK:      This is just a helper function. This function should only be
%              called from class functions.
%
% INPUTS:      z  - zero object
%              fs - the sample rate for the filter
%
% VERSION:     $Id$
%
% HISTORY:     03-04-2007 Hewitson
%                 Creation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VERSION  = '$Id$';
CATEGORY = 'Internal';

%%%%%   'Params' && 'Version' Call   %%%%%
if nargin == 2
  if isa(z, 'zero') && ischar(fs)
    in = fs;
    if strcmp(in, 'Params')
      a = plist();
      return
    elseif strcmp(in, 'Version')
      a = VERSION;
      return
    elseif strcmp(in, 'Category')
      a = CATEGORY;
      return
    end
  end
end

f0 = z.f;
q  = z.q;

w0  = f0*2*pi;
w02 = w0^2;

a(1) = (-q*w02/2 - 2*q*fs*fs - w0*fs) / (q*w02);
a(2) = (-w02+4*fs*fs) / w02;
a(3) = (-q*w02/2 - 2*q*fs*fs + w0*fs) / (q*w02);

b(1) =  1;
b(2) = -2;
b(3) = -1;

% END

