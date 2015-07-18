function ligoDV_start()
%% LigoDv startup script
% set paths for java scripts and .m files
global ranLdvStartup;
    if ~strcmpi(ranLdvStartup,'yes')


        % add paths to all our subdirectories
        myFilename = mfilename('fullpath'); % full path to this m-file which must be
                                            % in ligodv root for this to work
        [ligodvRootPath] = fileparts(myFilename);   %path to directory with this file

        addpath(genpath(ligodvRootPath));   % genpath finds all subdirectories

        %% set java paths for our jars
        jarPath = [ligodvRootPath '/jars'];
        t=exist(jarPath, 'dir');
        ermsg = '';
        
        if (t == 7)            
            jarList= dir([jarPath '/*.jar']);
            for j = [1:length(jarList)]
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
        %% detrmine what type of computer we're using
        matlabRel=version('-release');
        
        comp = computer;        % some paths vary depending on OS
        isWin=0;
        isMac=0;
        isLinux=0;
        pathSep = '/';
        if (~isempty(strfind(comp,'WIN')))
            isWin=1;
            pathSep='\';
        elseif (~isempty(strfind(comp,'MAC')))
            isMac=1;
        elseif (~isempty(strfind(comp,'LINUX')))
            isLinux=1;
        end
        %% add paths nds java interface
        ndsPath='';
        ndsErr=0;
        ermsg = '';
        
        % first we'll try the fancy new configuration info getter
        [st, res] = system('nds-client-config --javaclasspath');
        if (st == 0)
            ndsPath = verifyNdsPath(strtrim(res));
        elseif isMac
            [st, res] = system('/opt/local/bin/nds-client-config --javaclasspath');
            if (st == 0)
                ndsPath = verifyNdsPath(strtrim(res));
            end
        end
        if (isempty(ndsPath))
            % then we can try to see if they set an environment
            nds2Path = getenv('NDS2_LOCATION');

            % do some validation of paths.  This code should be good enough to
            % determine if the paths have been set correctly but is not complete enough
            % to validate the whole NDS/NDS2 installation
            if (~isempty(nds2Path))
                ndsPath = strcat(nds2Path,'/lib/java');
                ndsPath = verifyNdsPath(ndsPath);
            end
        end
        
        if (isempty(ndsPath))
            % we didn't get nds module from the environment
            dname=getHomeDir();
            if (isempty(dname))
                ermsg = 'No home directory available';
                disp ermsg;
            else
                % see if we saved it in our preferences/state directory
                ndspathfile = [dname pathSep 'ndspath.save'];

                if (exist(ndspathfile,'file'))
                    fileid = fopen(ndspathfile,'r');
                    ndsPath=fgetl(fileid);
                    %ndsPath = char(ndsPath{1});
                    fclose(fileid);
                    ndsPath = verifyNdsPath(ndsPath);
                    if (isempty(ndsPath))
                        delete(ndspathfile);
                    end
                end
                ndsPath = verifyNdsPath(ndsPath);
                
                while (isempty(ndsPath))
                    % we don't have it let's see if they can find it
                    ermsg = ['The Java interface classes were not found.  ', '', ...
                        'Without it we cannot get channel lists or transfer channel data.  ', ...
                        ' ', 'You may continue and use other methods to get data.'];
                    answer = questdlg(ermsg,'NDS2 Not Found','Continue','Browse','Exit','Exit');
                    if (strcmp(answer,'Exit'))
                        error(ermsg);
                    elseif (strcmp(answer,'Browse'))
                         ndsPath = uigetdir('java','Specify the Java directory in the NDS2 installation (.../lib/java not lib/java/nds2');
                         if (ndsPath ~= 0)
                             ndsPath = verifyNdsPath(ndsPath);
                             if (~isempty(ndsPath))
                                 % save it so we don't have to ask again
                                 fileid = fopen(ndspathfile,'w');
                                 fprintf(fileid,'%s\n',ndsPath);
                                 fclose(fileid);
                             end
                         end
                    elseif (strcmp(answer,'Continue'))
                            ndsPath='';
                        break;
                    end
                end
            end
            if (ndsPath == 0)
                ndsPath='';
            end
        end
        if ~isempty(ndsPath)
            javaaddpath(ndsPath);
        else
            ldvMsgbox('NDS bindigs are not available, you may not be able to pull data', ...
            'NDS not found');
        end
        % we only want to do this once
        ranLdvStartup = 'yes';
    end

    % there might be a way to do this on windows but I haven't figured it
    % out yet
    iswin = ~isempty(strfind(computer,'PCWIN'));
    if (~iswin)
        klistCmd = 'klist -s';
        if ~isempty(strfind(computer,'MAC'))
            % The way NDS2 java is implemented causes Macs to have 2
            % incompatible versions of Kerberos installed, try to pick the
            % correct one.
            if (exist('/opt/local/bin/klist','file'))
                klistCmd = '/opt/local/bin/klist -s';
            end
        end
        % check if we have a valid kerberos ticket
        [status, ~] = system(klistCmd);
        if (status ~= 0)
            msg ='There does not appear to be a valid Kerberos ticket.  You may want ';
            msg = [msg 'to open a terminal window and run "kinit albert.einstein@LIGO.ORG"'];
            msg = [msg '  You may continue but may not be able to access NDS2 servers'];
            ldvMsgbox(msg,'No kerberos ticket','warn');
        end
    end
    % OK now you can do what you wanted to do all along
    ligoDV;

end
