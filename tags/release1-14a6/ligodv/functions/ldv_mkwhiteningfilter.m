function mfilt = ldv_mkwhiteningfilter(x, fs, magTaps, infilter)

% LDV_MKWHITENINGFILTER make a whitening filter for a channel.
% 
% M Hewitson 11-08-06
% 
% $Id$
% 

% % we only need a little data to 
% x = x(1:min(10*fs, length(x)));

% apply filter
if ~isempty(infilter)
    Zi       = infilter.histout;
    [hout, Zf] = filter(infilter.a, infilter.b, x, Zi);
    infilter.histout = Zf;
else
  hout = x;
end

%% spectral analysis

nfft   = fs/4;
[hx,f] = pwelch(hout(1+fs:end), hann(nfft), 0.5*nfft, nfft, fs);

% make noise floor estimate
bw = 16;
hc = 0.6;
nf = sqrt(ldv_nfest(hx, bw, hc));

% correct for filter response
if ~isempty(infilter)
  [fd, fpresp] = ldv_iirfiltresp(f.', infilter);
  nf     = nf ./ abs(fpresp);
end

%% invert and make weights

nf = sqrt(hx) ./ abs(fpresp).';
w = 1./nf;

%% make filter

% for magnitude filter
ffm   = f/(fs/2);
win   = hann(magTaps+1);
mtaps = fir2(magTaps, ffm, w, win);

% convert to m-filt format
mfilt.name  = 'whitening';
mfilt.fs    = fs;
mfilt.ntaps = magTaps+1;
mfilt.L     = 1;
mfilt.R     = 1;
mfilt.gd    = magTaps/2;
mfilt.fc    = 1;
mfilt.a     = mtaps;
mfilt.gain  = 1;
mfilt.histL = magTaps;
mfilt.hist  = zeros(magTaps,1);

% fvtool(mtaps);
% write_mFIRfilt(mfilt, 'testWhitening')

% END

