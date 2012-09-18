function unit = ldv_setunit(handles)

% LDV_SETUNIT set the unit text box to the value from the dropdown box.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get selected unit
unit_long = ldv_getselectionbox(handles.preprocUnits);

if strcmp(unit_long,'Counts')
    unit = unit_long;
else
    unit = 'V';
end

% set unit box
% set(handles.plotUnitTxt, 'String', unit);



% END