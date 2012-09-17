function obj = ldv_selectobject(dobjs, id)

% LDV_SELECTOBJECT select a data object by its id number.
% 
% M Hewitson 10-08-06
% 
% $Id$
% 

obj = dobjs.objs([dobjs.objs.id] == id);


% END