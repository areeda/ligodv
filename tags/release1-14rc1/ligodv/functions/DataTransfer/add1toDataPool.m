function add1toDataPool( handles,sobj )
%ADD1TODATAPOOL Add a single object to the data pool
%   the object is usually created by the DataObject class, we put it into
%   the form that nds data transfers use and add it to the pool

    newobj.nobjs=1;
    newobj.objs(1) = sobj;
    
    addToDataPool(handles, newobj);

end

