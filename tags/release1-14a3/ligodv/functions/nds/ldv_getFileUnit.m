function unit = ldv_getFileUnit(dtype)

% LDV_GETFILEUNIT get the scale unit for a particular data type.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 
  switch dtype
    case 'raw data'
      unit = 1;      % one second chunks
    case 'second trends'
      unit = 1;   % one second chunks
    case 'minute trends'
      unit = 60;   % one minute chunks
    otherwise
     error('### unknow data type');
  end



% END