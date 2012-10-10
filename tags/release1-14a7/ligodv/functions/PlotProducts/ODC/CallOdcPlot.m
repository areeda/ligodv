%% Control the external (java) program to create ODC plots
function CallOdcPlot(handles)

% get the settings
    [dtype, server, port, times, channels] = gui_getDataSpec(handles);
  
    scrnSize = get(0,'ScreenSize');
    xoff=0;
    yoff=-100;
    shgt = scrnSize(4);
    swdt = scrnSize(3);
    
    ermsg = '';
    nTimes = times.ntimes;
    for  i = [1:nTimes]
        thisTime = times.t(i);
        
        startGPS = thisTime.startgps;
        duration = thisTime.stopgps - startGPS;
        mg=odcplot.MatlabGlue();
        tn=[tempname '.png'];
        try
            ret = mg.createImageFile(java.lang.Integer(startGPS),java.lang.Integer(duration),java.lang.String(tn));
        catch ex
            disp(ex);
        end
        if (strcmpi(ret,'success'))
            [img,map] = imread(tn,'png');
            [ihgt,iwdt] = size(img);
            hf=figure();
            ypos = shgt -ihgt + yoff;
            set(hf,'Position',[xoff,ypos,iwdt,ihgt]);
            xoff = xoff + 100;
            yoff = yoff - 50;
            colormap(map);
            image(img);

            set(gca,'xtick',[]);
            set(gca,'ytick',[]);

            set(gca,'Position',[0 0 1 1]);
            drawnow;
        else
            if (~isempty(ermsg))
                ermsg = [ermsg '\n' char(ret)];
            else
                ermsg = char(ret);
            end
        end 
    end
    if (~ isempty(ermsg))
        msgbox(ermsg,'OdcPlot did not complete');
    end
end