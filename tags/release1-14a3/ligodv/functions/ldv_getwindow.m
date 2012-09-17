function win = ldv_getwindow(nfft, type)

% LDV_GETWINDOW get a window function of a given type.
% 
% M Hewitson 10-08-06
% 
%  

switch type
  case 'Hanning'
    win = hann(nfft);
  case 'Bartlett'
    win = bartlett(nfft);
  case 'Blackmanharris'
    win = blackmanharris(nfft);
  case 'Kaiser'
    win = kaiser(nfft, 10*pi);
  case 'Flattop'
    win = flattopwin(nfft);
  case 'none'
    win = ones(nfft,1);
  otherwise
    error('### unknown window type');
end

