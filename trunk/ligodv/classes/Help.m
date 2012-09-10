classdef Help < handle
    %HELP Singleton class to open help wiki to the appropriate page
    %   The actual help text is contained in a wiki that will be hosted
    %   somewhere and managed by this class.  A singleton instance is
    %   created during startup and the methods facilitate one line calls to
    %   the context-sensitive page.
    
    properties (GetAccess = private, Constant)
        % urls we use
        wikiRoot = 'https://wiki.ligo.org/LDG/DASWG/';
        
        helpRoot = [Help.wikiRoot 'LigoDVHelp'];
        homePage = 'https://wiki.ligo.org/LDG/DASWG/LigoDV';
        
        updatePage = 'https://wiki.ligo.org/LDG/DASWG/LigoDVReleaseNotes';
        versionText = 'https://www.lsc-group.phys.uwm.edu/daswg/projects/ligodv/ligoDVVersion.txt';
    end
    
    methods (Static)
        
        function ret=getUpdatePage()
            % return the URL of the page they should go to if they want to
            % update
            ret = Help.updatePage;
        end
        
        function show(pageName)
            % launch a browser open to a specific Help wiki page depending on
            % context
            
            url = [Help.helpRoot pageName];
            web(url,'-browser');
        end
        
        
        function show2(pageName)
            % launch a browser open to a specific wiki page depending on
            % context
            
            url = [Help.wikiRoot pageName];
            web(url,'-browser');
        end
        
        function home()
            % Launch a browser to our home page
            
            web(Help.homePage,'-browser');
        end
        
        function checkForUpdate(bequiet)
            % Compare this version string with the website to see if a
            % newer version is available for updates.
            % if bequiet is true then we only check if we're a prelease
            
            global curVersion;
            
            cur = Help.parseVersion(curVersion);
            if (cur{1}{3} == 0 && bequiet)
                return;     % we are running a release version and this is
                            % an automatic check so don't do anything
            end
            
            verStr=urlread(Help.versionText);
            [id, remain] = strtok(verStr);
            
            
            if strcmp(id,'%lidgodv_version%')
                [webVer, remain] = strtok(remain);
                stat = Help.isNewer(webVer,curVersion);
                switch stat
                    case -2
                        mb = msgbox('Problem parsing version strings. Please file a bug report', ...
                            'No update available');
                            waitfor(mb);
                    case -1
                        if (~bequiet)
                            msg = sprintf('Your version (%s) is newer than what is available (%s)', ...
                                curVersion, webVer);
                            mb = msgbox(msg,'No update available');
                            waitfor(mb);
                        end
                    case 0
                        if (~bequiet)
                            msg = sprintf('You have the current version (%s)',curVersion);
                            mb = msgbox(msg, 'No update available');
                            waitfor(mb);
                        end
                    case 1
                        
                        [date, remain] = strtok(remain);
                        [url, remain] = strtok(remain);
                        updtdlg = UpdtDlg();
                        c=get(updtdlg,'Children');
                        for i=1:length(c)
                            t=get(c(i),'Tag');
                            switch t
                                case 'newVersionStr'
                                    set(c(i),'String', webVer);
                                case 'cautionStr'
                                    r = Help.parseVersion(webVer);
                                    if (r{1}{3} > 0)
                                        set(c(i),'String', 'Caution pre-release version');
                                    else
                                        set(c(i),'String', 'Recommended update');
                                    end
                                case 'curVersionStr'
                                    set(c(i),'String', curVersion);
                            end
                        end
                        waitfor(updtdlg);
                end
            else
                ed = errordlg('Problem getting current version from web','Latest version unknown');
                waitfor(ed);
            end
        end
        
        function ret = isNewer(webStr,curVerStr)
            % compare version strings to see if an update is available
            % returns 
            %   -2 -> problem parsing one of the strings
            %   -1 -> you are newer, 
            %    0 -> you have current, 
            %    1 -> newer version available for download
            
            w = Help.parseVersion(webStr);
            c = Help.parseVersion(curVerStr);
            % the token list is 1 - major, 2 - minor 3 - type 4 - revision
            
            if (length(c) ~= 1 || length(w) ~= 1)
                ret = -2;
            else
                % compare major
                if (w{1}{1} < c{1}{1})
                    ret = -1;
                elseif (w{1}{1} > c{1}{1})
                    ret = 1;
                % major is equal compare minor
                elseif (w{1}{2} < c{1}{2})
                    ret = -1;
                elseif (w{1}{2} > c{1}{2})
                    ret = 1;
                % major and minor are equal how about type
                % null type means we have a first relase of this version
                elseif (length(w{1}{3}) == 0 && length(c{1}{3}) == 0)
                    ret = 0;
                % type orders . > rc > b > a
                elseif (w{1}{3}~=10 & c{1}{3}==10)
                    ret = -1;
                elseif (w{1}{3}==10 & c{1}{3} ~= 10)
                    ret = 1;
                elseif (w{1}{3} < c{1}{3})
                    ret = -1;
                elseif (w{1}{3} > c{1}{3})
                    ret = 1;
                % all is equal to here how about rev#
                elseif (w{1}{4} < c{1}{4})
                    ret = -1;
                elseif (w{1}{4} > c{1}{4})
                    ret = 1;
                else
                    % they are the same
                    ret = 0;
            end
        end

        end
        function ret = parseVersion(vstr)
            % parse version strings according to 
            % https://ligodv.areeda.com/wiki/LigoDV_Version_Numbering
            % returns a 1x4 cell array if succssful with
            % 1-major, 2-minor, 3 -type (or null string) 4 - rev
            vpat='(\d+)\.(\d+)(\.|a|b|rc){0,1}(\d+){0,1}';
            ret = regexpi(vstr,vpat,'tokens');
            if (~isempty(ret))
                ret{1}{1} = str2double(ret{1}{1});
                ret{1}{2} = str2double(ret{1}{2});
                if (isempty(ret{1}{3}))
                    ret{1}{3} = 0;
                else
                    switch ret{1}{3}
                        case 'a'
                            ret{1}{3} = 1;
                        case 'b'
                            ret{1}{3} = 2;
                        case 'rc'
                            ret{1}{3} = 3;
                        case '.' 
                            ret{1}{3} = 10;
                        otherwise
                            ret = {};
                    end
                end
            end
        end
    end % Public Static Methods
    
    methods (Access = private)
        
    function obj = Help()
        % Constructor is private meaning anyone wanting an object needs
        %   to call our getInstance method.

    end


            
    end
    
end

