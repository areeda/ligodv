function h = ldvMsgbox(varargin)
% Make the message boxes look prettier
    textChildn = 1;
    btnChildn = 2;
    txt = varargin(1);
    if (~iscell(txt))
        txt = char(txt);
    else
        if (iscell(txt(1)))
            % I have no idea why we have to do this???
            txt = txt{1};
        end
    end
    
    switch(nargin)
        case 1,
            h = msgbox(txt,'modal');
        case 2,
            h = msgbox(txt, char(varargin(2)),'modal');
        case 3,
            h = msgbox(txt, char(varargin(2)), char(varargin(3)),'modal');
            textChildn = 2;
            btnChildn = 3;
        otherwise,
            h = msgbox(varargin);
    end
    set(h,'Color',[.95 .95 .95]); % background color to white
    
    % make it a bit bigger
    enlargeFactor = 1.1;
    pos=get(h,'Position'); 
    oldwidth = pos(3);
    newwidth = oldwidth * enlargeFactor;
    pos(3) = newwidth;
    pos(1) = pos(1) - (newwidth-oldwidth)/2;
    
    oldheight = pos(4);
    newheight = oldheight * enlargeFactor;
    pos(4) = newheight;
    pos(2) = pos(2) - (newheight - oldheight)/2;
    
    set(h,'Position',pos);
    
    % make the fonts a bit bigger to be readable
    ah = get( h, 'Children' );
    ch = get( ah(textChildn), 'Children' );
    set( ch, 'FontSize', 12 );
    set(ch,'FontName','Times');
    set(ah(btnChildn),'BackgroundColor',[.95 .95 .95]);
    %uiwait(h);     % this presents problems on windows
end

