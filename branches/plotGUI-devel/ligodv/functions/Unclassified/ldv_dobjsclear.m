function ldv_dobjsclear(handles)

% LDV_DOBJSCLEAR clear all data objects and reset list. 
% 
% M Hewitson 27-07-06
% 
% $Id$
% 

dobjs.objs  = [];
dobjs.nobjs = 0;
dobjs.counter = 0;
setappdata(handles.main, 'dobjs', dobjs);
ldv_setnobjsdisplay(handles, dobjs);
ldv_setdobjslist(handles, dobjs);
ldv_setdobjinfo(handles);


% END
