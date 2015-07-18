function ldv_setStatus( statTxt )
%LDV_SETSTATUS Set the status text on the main GUI
%   Detailed explanation goes here

    mainHandle=findobj('Name','ligoDV');
    kids = get(mainHandle,'Children');
    statH = [];
    for k=1:size(kids)
        tag = get(kids(k),'Tag');
        if (strcmpi(tag,'dvStatus'))
            statH = kids(k);
            break;
        end
    end
    if (~isempty(statH))
        set(statH,'String',statTxt);
        drawnow
    end
end

