function ldv_setnobjsdisplay(handles, dobjs)

% LDV_SETNOBJSDISPLAY set the number of objects display.
% 
% M Hewitson 26-07-06
% 
% $Id$

% dobjs = getappdata(handles.main, 'dobjs');

set(handles.nobjsDisplay, 'String', dobjs.nobjs);


% END