%% Channel Type conversions (string <-> number)
classdef ChannelType
    %ChanntelType conversions between internal numeric types and strings
    %   This should move to the libraries and be based on  the server
    
    properties (Constant)
        tbl = struct('code',{1,2,4,8,16,32,64},'name',{'online','raw','reduced','s-trend','m-trend','test_point','static'});
        CHANNEL_TYPE_ONLINE = 1;
        CHANNEL_TYPE_RAW = 2;
        CHANNEL_TYPE_RDS = 4;
        CHANNEL_TYPE_STREND = 8;
        CHANNEL_TYPE_MTREND = 16;
        CHANNEL_TYPE_TEST_POINT = 32;
        CHANNEL_TYPE_STATIC = 64;
    end
    % fast lookup for inner loops
    properties (SetAccess = private, GetAccess = public)    % public get is for debugging only
        lookup;
    end
    
    methods (Static)
        function code=str2code(typeName)
            code=0;
            
            for e= ChannelType.tbl
                if (strcmpi(e.name,typeName))
                    code=e.code;
                    break;
                end
            end
                
        end
        
        function name=code2str(code)
            name='';
            for e= ChannelType.tbl
                if (e.code == code)
                    name=e.name;
                    break;
                end
            end
        end
    end
     methods
        function this=ChannelType()
            this.lookup{1} = 'online';
            this.lookup{2} = 'raw';
            this.lookup{4} = 'reduced';
            this.lookup{8} = 's-trend';
            this.lookup{16} = 'm-trend';
            this.lookup{32} = 'test_point';
            this.lookup{64} = 'static';
        end
        
        function ret=getName(this,code)
            ret = this.lookup{code};
        end
    end
end

