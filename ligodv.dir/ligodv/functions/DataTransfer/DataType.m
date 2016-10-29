%% DataType conversions str <--> code
classdef DataType
    %DataType internal data type to string conversions
    %   This should be moved to the nds libraries
    
    properties (Constant)
        DATA_TYPE_INT16 = 1;
        DATA_TYPE_INT32 = 2;
        DATA_TYPE_INT64 = 4;
        DATA_TYPE_FLOAT32 = 8;
        DATA_TYPE_FLOAT64 = 16; 
        DATA_TYPE_COMPLEX32 = 32; 
        DATA_TYPE_ALL = 32+16+8+4+2+1;
        
        tbl = struct('code',{1,2,4,8,16,32},'name',{'INT16','INT32','INT64','FLOAT32','FLOAT64','COMPLEX32'});
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
        
        function nbytes = getBytesPerSample(code)
            switch code
                case DataType.DATA_TYPE_INT16
                    nbytes=2;
                case DataType.DATA_TYPE_INT32
                    nbytes=4;
                case DataType.DATA_TYPE_INT64
                    nbytes=8;
                case DataType.DATA_TYPE_FLOAT32
                    nbytes = 4;
                case DataType.DATA_TYPE_FLOAT64
                    nbytes = 8;
                case DataType.DATA_TYPE_COMPLEX32
                    nbytes = 8;
                otherwise
                    nbytes = 0;
            end
        end
    end
    
    methods
        function this=DataType()
            this.lookup{1} = 'INT16';
            this.lookup{2} = 'INT32';
            this.lookup{4} = 'INT64';
            this.lookup{8} = 'FLOAT32';
            this.lookup{16} = 'FLOAT64';
            this.lookup{32} = 'COMPLEX32';
        end
        
        function ret=getName(this,code)
            ret = this.lookup{code};
        end
    end
end

