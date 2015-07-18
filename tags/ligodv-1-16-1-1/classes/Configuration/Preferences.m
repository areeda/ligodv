classdef Preferences < handle
    %PREFERENCES encapsulate preferences and configuration management
    %   This is a singleton class so either call the static methods or use
    %   Preferences.instance() to get the one and only Preferences object
    
    properties (GetAccess = private)
        handles;        % ligoDV.fig handles (all the UI widgets)
        saveDir;            % full path to our save directory
        valid = 0;      % if we can't get our folder or other problems don't do anything
        configList;     % saved configuration objects
        defaultCname = '__default__';   % special name for default config
    end
    
    methods (Static)
        
        function this=instance()
             persistent uniqueInstance;
             
             if isempty(uniqueInstance)
                this = Preferences();
                uniqueInstance = this;
             else
                this = uniqueInstance;
             end           
        end
                
    end
    
    methods(Access = public)
           
        function setHandles(this, h)
            % set the handles to the ligoDV UI, it's only done once during
            % startup
            this.handles = h;
        end
        
        function showDlg(this)
            % Presents the preference dialog.  All the dialog functions are
            % handled by callbacks.  see PrefDlg.m
            if this.valid > 0
                PrefDlg();
            else
                ldvMsgbox('Preferences unavailable','Preferences error','error');
            end
        end
        
        function data = getUIListData(this)
            % generate the cell array of name, description for each
            % config
            % returns cellarray{n,1} of Strings separated by '|'
            
            this.reload();      % make sure this matches what we have on disk
            
            n=length(this.configList);
            data=cell(n,1);
            for i= 1:n;
                c = this.configList{i};
                data{i, 1} = sprintf('%-20.20s | %s',c.getName(),c.getDescription());
            end
        end
        
        function didit = apply(this,selections)
            % apply the selected configuration
            % Unfortunately, I haven't figured out what to do with multiple
            % selections.
            didit = 0;
            s = size(selections);
            if s(1) ~= 1 || s(2) == 0
                ed = errordlg('You must select exactly one configuration','Can not apply', 'modal');
                waitfor(ed);
            else
                cn = selections(1);
                c = this.configList{cn};
                c.apply(this.handles);
                didit = 1;      % it's ok to close the dialog now
            end
        end
        
        function setDefault(this)
            % if we have a default configuration apply it now
            % no default is normal
            
            this.reload();      % only done on init so we probably don't have
            for idx=1:length(this.configList)
                c = this.configList{idx};
                curName = c.getName();
                if strcmp(this.defaultCname, curName)
                    c.apply(this.handles);
                    break;
                end
            end
        end
        
        function remove(this,selections)
            s = size(selections);
            n = s(1);
            for i=1:n
                cn = selections(i);
                c = this.configList{cn};
                f = c.getFilename();
                delete(f);
                disp (['deleted configuration:' cn]);
            end
                
        end
        
        function saveDefault(this)
            % save the current settings to a special name for loading on
            % start
            cname = this.defaultCname;
            c = Configuration(cname, 'Default automatically loaded on start');
            c.getCurrent(this.handles);
            
            fullName = strcat(this.saveDir, '/', cname, '.ldv_config');
            c.save(fullName);
        end
        %----Dialog Callback functions------
        
        function reset(this)
            % reset all settings to factory defaults
            global factDefConfig;
            factDefConfig.apply(this.handles);
        end
        
        function save(this)
            % Create a new configuration from the main fig and save it.
            
            prompt = {'Name:', 'Description:'};
            lines = [1 32; 1 80];
            resp = inputdlg(prompt,'New Configuration',lines);
            s = size(resp);
            if (s(1) == 2)
                c = Configuration(resp(1), resp(2));
                c.getCurrent(this.handles);
                cname = regexprep(resp(1),'[^(\w\d_\-)]','_');
                fullName = strcat(this.saveDir, '/', cname, '.ldv_config');
                fullName = lower(fullName);
                c.save(fullName);
            end
        end
    end
    
    methods (Access = private)
        
        function this = Preferences()
            % Constructor is private meaning anyone wanting an object needs
            %   to call our instance() method.
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
            
            this.saveDir =  [ d '.ligodv' ];
            de = exist(this.saveDir,'dir');
            if (de == 0)
                % directory does not exit, create it
                [stat, mesg] = mkdir(this.saveDir);
                if stat ~= 1
                    m = ['Error creating "' this.saveDir '" ' mesg ' No preferences available.'];
                    ldvMsgbox(m,'Creating Preferences Directory','error');
                else
                    this.valid = 1;
                end
            elseif de ~= 7
                % something is there but it's not a directory
                m = 'Something other than a folder conflicts with our preferences directory: ';
                m = [m this.saveDir '.  Preferences will be unavailable.'];

                ldvMsgbox(m,'Creating Preferences Directory','error');
            else
                % directory already exists we're good
                this.valid = 1;
            end
        end
        
        function reload(this)
            % scan our directory and (re)create all structures and objects
            srchStr = [this.saveDir '/*.ldv_config'];
            dirList = dir(srchStr);
            n = length(dirList);
            this.configList = cell(n,1);
            for i=1:n
                f = dirList(i);
                fullyQualifiedName = [this.saveDir '/' f.name];
                c = Configuration('','');
                c.load(fullyQualifiedName);
                this.configList{i} = c;
            end
        end
    end
    
end

