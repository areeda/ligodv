function [varargout] = verifyNdsPath( inpath )
%VERIFYNDSPATH Check as much as we can about the directory specified as
%holding the nds clases.

%   inpath = proposed path
%   outpath = one we like or null string
%
%   we look down the directory tree for the class files we need

    outpath=''; % guilty until proven innocent
    ermsg='';   % that will hold the reason we've rejected it
    testPath = inpath;
    
    if (~isempty(testPath))
        if (exist(testPath,'dir'))
            % check if they did it right
            t = [testPath '/nds2'];
            if (exist(t,'dir'))
                outpath = testPath;
            else
                % we can accept the lib directory above the one we really
                % want
                t = [testPath '/java/nds2'];
                if (exist(t,'dir'))
                    outpath = [testPath '/java'];
                else
                    % we can also accept the NDS_LOCATION that the
                    % environment script sets
                    t = [testPath '/lib/java/nds2'];
                    if (exist(t,'dir'))
                        outpath = [testPath '/lib/java'];
                    else
                        ermsg = 'directory does not have the expected class file dir';
                    end
                end
            end
        elseif (exist(testPath,'file') && ~ isempty(regexp(testPath,'\.jar$','ONCE')))
            outpath = testPath;
        else
            ermsg = 'Specified path is not a directory or a jar file';
        end
    else
        ermsg = 'Path is empty';
    end
    varargout{1}  = outpath;
    if (nargout == 2)
        varargout{2} = ermsg;
    end
end

