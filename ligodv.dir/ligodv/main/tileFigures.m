function tileFigures(  )
%TILEFIGURES Find all open figures are resize and move them around to fill
%the screen
%   Sort of making it up as I go.  I try to explain it when it works

    f=findobj('Type','figure'); 
    % that should give us all open figures but not all of them are plots
    np = 0;
    for i=1:size(f)
        nam = get(f(i),'Name');
        nam = lower(nam);
        if strfind(nam,'plot')
            np = np +1;
            plotList{np} = nam;
            plotNum(np) = f(i);
        end
    end
    if np > 0
        nrows = floor(sqrt(np));
        ncols = ceil(np/nrows);
 
        scrn = get( 0, 'ScreenSize' );
        w = scrn(3) - 100;
        h = scrn(4) - 50;
        fw = w / ncols;
        fh = h / nrows;
        for n=1:np
            r = nrows - 1 - floor((n-1)/ncols);
            c = mod((n-1),ncols);
            x = c * fw;
            y = r * fh;
            p = [x + 75, y + 40, fw, fh-90];
            %fprintf('%d: %d,%d (%d,%d) %dx%d\n' ,n,r,c,p(1),p(2),p(3),p(4));
            set(plotNum(n),'Position',p);
            figure(plotNum(n));   % bring it to the front
        end
    end
end

