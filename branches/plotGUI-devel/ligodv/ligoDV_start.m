%% LigoDv startup script
if ~exist('ranLdvStartup','var')
    % we only want to do this once
    ranLdvStartup = 'yes';
    
    % add paths to all our subdirectories
    myFilename = mfilename('fullpath'); % full path to this m-file which must be
                                        % in ligodv root for this to work
    [ligodvRootPath] = fileparts(myFilename);   %path to directory with this file

    addpath(genpath(ligodvRootPath));   % genpath finds all subdirectories

    %%
    jarPath = [ligodvRootPath '/jars'];
    t=exist(jarPath, 'dir');
    ermsg = '';
    if (t == 7)
        jarList= dir([jarPath '/*.jar']);
        for(j = [1:length(jarList)])
            jar = jarList(j);
            jarName = [jarPath '/' jar.name];
            javaaddpath(jarName);
        end
        else
            ermsg = sprintf('\nODC Plot functions OdcPlot.jar, not found\n\n%s\n',...
                'If you continue you will not have access to this plotting function');
    end
    if (~isempty(ermsg))
        answer = questdlg(ermsg,'ODC plot not Found','Continue','Exit','Help','Exit');
        if (strcmp(answer,'Exit'))
            error(ermsg);
        elseif (strcmp(answer,'Help'))
            Help.show2('NDS2_Install#Troubleshooting');
            error(ermsg);
        else
            warning(ermsg);
        end
    end
    %% add paths nds java interface
    matlabRel=version('-release');
    nds2Path = getenv('NDS2_LOCATION');
    comp = computer;        % some paths vary depending on OS


    ndsErr=0;
    ermsg = '';

    % do some validation of paths.  This code should be good enough to
    % determine if the paths have been set correctly but is not complete enough
    % to validate the whole NDS/NDS2 installation
    if (isempty(nds2Path))
        ermsg=sprintf('\nNDS2 libraries were not found.\n\n%s\n%s\n', ...
            'The easiest way to fix this is to set the environment variable "NDS2_LOCATION"\n',...
            'If you continue you will not have access to remote data');
        ndsErr = 1;
    else
        jarPath = strcat(nds2Path,'/share/java/nds.jar');
        if (exist(jarPath,'file') == 2)
            javaaddpath(jarPath);
        else
            ermsg = sprintf('\nSWIG-Java bindings, nds.jar, not found\n\n%s\n',...
                'If you continue you will not have access to remote data');
            ndsErr=1;
        end
    end

    if (ndsErr == 1)
        % we didn't get nds module from the envirnment
        dname=getHomeDir();
        jarpath='';
        if (isempty(dname))
            ermsg = 'No home directory available';
        else
            % see if we saved it in our preferences/state directory
            ndspathfile = [dname '/' 'ndspath.save'];
            
            if (exist(ndspathfile,'file'))
                fileid = fopen(ndspathfile,'r');
                jarpath=textscan(fileid,'%s');
                jarpath = char(jarpath{1});
                fclose(fileid);
            else
                % we don't have it let's see if they can find it
                answer = questdlg(ermsg,'NDS2 Not Found','Continue','Browse','Exit','Exit');
                if (strcmp(answer,'Exit'))
                    error(ermsg);
                elseif (strcmp(answer,'Browse'))
                     [f, p] = uigetfile('nds.jar','Specify NDS interface file (nds.jar)');
                     if length(f) > 1 && length(p) > 1
                         jarpath=[p f];
                         % save it so we don't have to ask again
                         fileid = fopen(ndspathfile,'w');
                         fprintf(fileid,'%s\n',jarpath);
                         fclose(fileid);
                     end
                end
            end
        end
            
        if ~isempty(jarpath)
            javaaddpath(jarpath);
        else
            msgbox('NDS bindigs are not available, you may not be able to pull data', ...
            'NDS not found');
        end
    end
end
    
% check if we have a valid kerberos ticket
[status, result] = system('klist');
if (status ~= 0)
    msg ='There does not appear to be a valid Kerberos ticket.  You may want ';
    msg = [msg 'to open a terminal window and run "kinit albert.einstein@LIGO.ORG"'];
    msg = [msg '  You may continue but may not be able to access NDS2 servers'];
    msgbox(msg,'No kerberos ticket','warn');
end

% OK now you can do what you wanted to do all along
ligoDV;


        