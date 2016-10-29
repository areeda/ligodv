function pobj = ldv_getprimaryobject(dobjs, handle)

% LDV_GETPRIMARYOBJECT get the object that matchs that given in the primary
% channel list specified by handle.
% 
% M Hewitson 10-08-06
% 
% $Id$
% 

% what is selected?
pchan = ldv_getselectionbox(handle);

% what is the id?
id = str2num(strtok(pchan, ':'));

% get this object
pobj = ldv_selectobject(dobjs, id);





% END