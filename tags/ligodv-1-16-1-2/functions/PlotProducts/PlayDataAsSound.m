function PlayDataAsSound( handles )
%PLAYDATAASSOUND play all selected objects as audio
%   if the object is sampled at too low a frequency we'll interpolate it up

    % get selected objects
    didx  = ldv_getselecteddobjs(handles);
    dobjs = getappdata(handles.main, 'dobjs');

    if ~isempty(didx)

        for idx = 1:length(didx)
            obj = dobjs.objs(didx(idx));
            name = obj.channel;
            len = obj.stopgps - obj.startgps;
            fs   = obj.data.fs;
            x = obj.data.x;
            x = x - mean(x);    % center it around 0
            if (fs >= 1024)
                fprintf('Play %s, %d seconds at %dHz\n',name,len,fs);
                sound(x,fs);
            else
                fs2=1024;   % seems to be the min sample rate we can play
                t=0:1/fs:len-1/fs;
                t1=0:1/fs2:len-1/fs2;
                x1=interp1(t,x,t1);
                sound(x1,fs2);
            end
        end
    end
end

