function addToDataPool( handles, newobjs )
%ADDTODATAPOOL Summary of this function goes here
%   Detailed explanation goes here

    % get existing dobjs
    dobjs = getappdata(handles.main, 'dobjs');
    dobjs = ldv_dobjsunique(dobjs,newobjs,handles);
    
    % set list of objects
    setappdata(handles.main, 'dobjs', dobjs);
    % Maintain object selection
    try
        didx  = ldv_getselecteddobjs(handles);
    catch ex
        didx = [];
    end
    if isempty(didx)
        didx = 1;
    end
    ldv_setnobjsdisplay(handles, dobjs);
    ldv_setdobjslist(handles, dobjs, didx(didx<dobjs.nobjs));
    drawnow;  % make sure the new objects are shown
end

