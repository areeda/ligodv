function dname = getHomeDir(  )
%GETHOMEDIR Find the directory we use for preferences
%   Detailed explanation goes here

    d = getenv('HOME');
    % Windows is special (as in Special Olympics)
    comp = computer;
    if (regexpi(comp,'PCWIN'))
        homeDrive = getenv('HOMEDRIVE');
        homePath = getenv('HOMEPATH');
        homePath = strrep(homePath,'\','/');
        d = [ homeDrive  homePath];
    end
    % Avoid double //'s for brain dead file systems
    r=regexp(d,'/$', 'once');
    if (isempty(r) )
        d = [ d '/' ];
    end

    saveDir =  [ d '.ligodv' ];
    de = exist(saveDir,'dir');
    if (de == 0)
        % directory does not exit, create it
        [stat, mesg] = mkdir(saveDir);
        if stat ~= 1
            m = ['Error creating "' saveDir '" ' mesg ' No home directory for saving state/settings available.'];
            ldvMsgbox(m,'Creating Preferences Directory','error');
        
        end
    elseif de ~= 7
        % something is there but it's not a directory
        m = 'Something other than a folder conflicts with our preferences directory: ';
        m = [m saveDir '.  State and settings cannot be saved.'];

        ldvMsgbox(m,'Creating Preferences Directory','error');
        dname = '';
    else
        % directory already exists we're good
        dname = saveDir;
    end

end

