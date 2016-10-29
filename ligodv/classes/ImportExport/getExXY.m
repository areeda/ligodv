function [ xy, varargout] = getExXY( obj,n )
%getExXY - get a 2 column Matrix from exported Ligodv object, 
%
% Input:
% obj - an export LigoDV object usually called ex_objs_NN
% n - which series in the object, starting with 1
%
% Output:
% xy - 2 Column matrix (:,1) is GPS time in seconds, (:,2) is the channel
% data
% chName (optional) returns the name of the channel for this object
%%

    % try to give some meaningful error messages
    ermsg = '';
    if (~isstruct(obj))
        ermsg = 'First agrument must be an ex_objs structure';
    elseif (~ isfield(obj,'nobjs') || obj.nobjs < 1)
        ermsg = 'not a valid export object';
    elseif (n < obj.nobjs)
        ermsg = 'invalid object number';
    else
        o = obj.objs(n);
        do = DataObject;
        do.initFromObj(o);
        chName = do.getChanName();
        xy = do.getXY();
        if (nargout > 1)
            varargout{1} = chName;
        end
    end
    if (~isempty(ermsg))
        error(ermsg);
    end

end
