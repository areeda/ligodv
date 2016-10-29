function str = ldv_getselectionbox(handle)

% LDV_GETSELECTIONBOX gets the currently selected string from a drop-down
% menu.
% 
% M Hewitson 25-07-06
% 
% $Id$
% 

strs = get(handle, 'String');
val  = get(handle, 'Value');
str  = strs{val};

% END