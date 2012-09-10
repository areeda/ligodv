function ldv_setcombinemath(handles)

% LDV_SETCOMBINEMATH set the default math string used to combine objects
% based on the number of objects selected.
% 
% JR Smith 2008/06/18
% 
% $Id$
% 

% get indices of selected data objects
objsidx = ldv_getselecteddobjs(handles);
% get all data objects
dobjs   = getappdata(handles.main, 'dobjs');

% If less than two objects are selected do not activate the Math string
if length(objsidx) < 2
    set(handles.combineObjsMathTxt, 'String', '');
    return;
else
    % If two or more selected, make string of added components x1+x2+...xN
    mathstr = [];
    for n=1:length(objsidx)
        if n==1
            mathstr = [mathstr 'x',num2str(dobjs.objs(objsidx(n)).id)];
        else
            mathstr = [mathstr '+x',num2str(dobjs.objs(objsidx(n)).id)];
        end
    end
    set(handles.combineObjsMathTxt, 'String', mathstr);
end



% END