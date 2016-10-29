function label = ldv_chan2label(channel)

% LDV_CHAN2LABEL convert a channel string to something that can be used for
% a label.
% 
% M Hewitson 10-08-06
% 
% $Id$
% 

label = strrep(channel, '_', '\_');


% END