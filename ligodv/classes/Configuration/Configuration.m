classdef Configuration < handle
    %CONFIGURATION holds all the optional setting 
    %   This class encapsulates the XML external files each containing one
    %   configuration.  It extracts values from the handles structure and
    %   restores them and reads and writes the individual files.
    
    % To add a panel of saved parameters:
    %   1.  Add variables to the properties in an appropriately commented
    %       section.  These should be named the same as their GUI
    %       counterpart.
    %   2.  Set the properties in this.getCurrent
    %   3.  Update this.makeXML to add a new panel and create
    %       a addXXX method if necessary,
    %   4.  Update the addXXX method to write out the new properties
    %   5.  Update digestXML to call loadXXX and create that method if
    %       necssary
    %   6.  Update the loadXXX method to set properties
    %   7.  Update apply method to call applyXXX
    %   8.  Create/Update applyXXX to set the UI and all any needed
    %       functions.
    
    properties (SetAccess = private, GetAccess = public)    % public get is for debugging only
        
        % About the Configuration itself
        cname;                  % string identifing this config
        description ='<none>';  % string to help you remember what is saved
        fileName;               % if we've read or written this will be set
        
        % Server panel
        dvmode;         % data retrieval mode (NDS or NDS2 Server);
        gd_dataType;    % raw or trend ...
        server;         % server FQDN eg nds.ligo.caltech.edu
        port;           % tcp port number
        rdsLevel;       % reduced dataset level (may be deprecated)
        calVersion;     % calibration version
        gdStat;         % statistic type (mean, min, max...)
        
        %Time Settings panel
        timeInputMode;              % UTC or GPS
        singleTimeRB;               % Use a single time interval
        timeListRB;                 % Use a list of time intervals
        gpsStartInput;              % interval start if GPS mode
        utcStartInput;              %   if UTC mode
        gpsStopInput;               % interval stop if GPS
        utcStopInput;               %   if UTC mode
        commentInput;               % comment on Times Settings
        timeList;                   % list of start/stop times
        
        % Channel Select panel
        channelSearchTxt;           % Search string
       
        channelList;                % List of SELECTED channels
        
        % xml document
        docNode;        % document itself for writing
        doc;            % the document tree from reading
    end
    
    methods
        function this = Configuration(name,desc)
            % Construct a named configuration
            this.cname = name;
            this.description = desc;
        end
        
        function getCurrent(this,handles)
            % Read the current values from the GUI and set our properties
            % handles structure passed contains almost everything we know
            % about.  See ldv_init
            
            % Server panel
            this.dvmode          = this.getDropDown(handles.dvmode);
            this.gd_dataType     = this.getDropDown(handles.gd_dataTypeSelect);
            this.server          = get(handles.gd_serverInputTxt,'String');
            this.port            = get(handles.gd_portInputTxt,'String');
            this.rdsLevel        = get(handles.gd_rdslevel,'String');
            this.calVersion      = get(handles.gd_calversion,'String');
            this.gdStat          = this.getDropDown(handles.gd_stat);
            
            % Time index panel
            this.timeInputMode  = this.getDropDown(handles.timeInputMode);
            this.gpsStartInput  = get(handles.gpsStartInput,'String');
            this.gpsStopInput   = get(handles.gpsStopInput,'String');
            this.utcStartInput  = get(handles.utcStartInput,'String');
            this.utcStopInput   = get(handles.utcStopInput,'String');
            this.commentInput   = get(handles.commentInput,'String');
            
            this.singleTimeRB   = get(handles.singleTimeRB,'Value');
            this.timeListRB     = get(handles.timeListRB,'Value');
            
            % we need to save the list of times, whether they are using it
            % or not.  
            this.timeList=getappdata(handles.main,'times');
            
            %Channel List/Select Panel
            this.channelSearchTxt       = get(handles.channelSearchTxt, 'String');
            
            
            % bit of reading their minds
            chListSize = length(get(handles.channelList,'String'));
            chSelSize = length(get(handles.channelList,'Value'));
            if (chListSize < 50 && chSelSize < 2)
                % assume they don't want to save just one channel from an
                % already short list
                this.channelList = get(handles.channelList,'String');
            else
                % OK now they have to pay attention if they want to keep
                % all entries in a short list because we are only going to
                % save the selections
                this.channelList = this.getListSelections(handles.channelList);
            end
            
            
        end
        
        function save(this,filename)
            % Write the current configuration to the file specified
            % filename probably should be fully qualified but we accept
            %   relative paths also, file will be overwritten without
            %   confirmation if it exists (do that before calling us)
            
            % I really don't understand why this is necessary but it is
            % needed sometimes depending on how filename is created
            fn = filename;
            if (iscellstr(fn))
                fn = char(fn);
            end
            
            xmlDoc = this.makeXml();
            
            % Save the sample XML document.
            xmlwrite(fn,xmlDoc);
            this.fileName = fn;
        end
        
        function load(this, filename)
            % Read the specified configuration
            % filename probably should be fully qualified but we'll accept
            % anything we can open
            
            try
                if (exist(filename,'file') == 2)
                    d = xmlread(filename);
                    this.doc = d;
                    this.digestXml();
                    this.fileName=filename;
                end
            catch e
                 error('Unable to read XML file %s. %s',filename, e.message);
            end
        end
        
        function apply(this, handles)
            % set the gui to the values in this configuration
            % while all the configurations are probably load'ed by the
            % Preference Manager, only one is apply'ed
            
            this.applyServer(handles);
            this.applyTimeIndexPanel(handles);
            this.applyChannelList(handles);
        end
        
        function name = getName(this)
            % get the user defined name
            name = this.cname;
        end
        
        function description = getDescription(this)
            % comment entered by user
            description = this.description;
        end
        
        function fileName = getFilename(this)
            % get the filename used to read or write last
            fileName = this.fileName;
        end
        
    end     %public methods
    
    methods (Access=protected)
        
        %-----------------------
        % Methods to extract data from handles structures
        
        function str = getDropDown(this,handle)
            % Get the current value from a drop down menu GUI object
            % handle: hanle of the object
            % returns string representing the current selection
            
            strs = get(handle,'String');
            val = get(handle,'Value');
            str = strs{val};
        end
        
        function chrCellArray = getListSelections(this, h)
            % Get the selected entries in a List box
            % h - handle to List box
            % returns a cell array of strings holding the selection
            
            charMtrx = get(h,'String');
            listContents = cellstr(charMtrx);   % cell array is easier to deal with
            vals = get(h,'Value');              % vector of selections
            n = length(vals);                   % how many selections
            chrCellArray = cell(n,1);
            
            for i=1:n
                idx = vals(i);
                chrCellArray{i} = listContents{idx};
            end
        end
        
        %-----------------------
        % Methods to set data in the handles structures
        
        function str = setDropDown(this,handle,newVal)
            % Get the current value from a drop down menu GUI object
            % handle: hanle of the object
            % returns string representing the current selection
            
            strs = get(handle,'String');
            n = length(strs);
            for(i=1:n)
                if(strcmpi(strs(i),newVal))
                    set(handle,'Value',i);
                end
            end
        end
        
        %----------------------
        % Methods to Create XML files
        
        function doc = makeXml(this)
            % Serialize this object as an xml document
            
             % Create a sample XML document.
            this.docNode = com.mathworks.xml.XMLUtils.createDocument('ligodvConfig');
            root = this.docNode.getDocumentElement;
            root.setAttribute('version','1');
            
            this.addTextEl(root, 'name', this.cname);
            this.addTextEl(root, 'description', this.description);
            this.addTextEl(root, 'usage', 'Used by ligoDV to save and restore most UI settings');

            this.addServerPanel(root);
            this.addTimeIndexPanel(root);
            this.addChannelSelectPanel(root);

           doc=this.docNode;
        end
        
        function addServerPanel(this,root)
           % Add all saved parameters relating to the server panel
           % root - node to which we append a single node containing our
           %    parmeters
           
           serv = this.docNode.createElement('Server');
           this.addTextEl(serv, 'dvmode', this.dvmode);
           this.addTextEl(serv, 'gd_dataType', this.gd_dataType);
           this.addTextEl(serv, 'server', this.server);
           this.addTextEl(serv, 'port', this.port);
           this.addTextEl(serv, 'rdsLevel', this.rdsLevel);
           this.addTextEl(serv, 'calVersion', this.calVersion);
           this.addTextEl(serv, 'gdStat', this.gdStat);
           
           root.appendChild(serv);
        end
        
        function addTimeIndexPanel(this,root)
            % Add all the parameters related to which time indexes to pull
            %   from the server
            % root - node to which we append a single node containing our
            %   parameters
            
            timeIdx = this.docNode.createElement('TimeSettings');
            this.addTextEl(timeIdx,'timeInputMode', this.timeInputMode);
            this.addTextEl(timeIdx,'gpsStartInput', this.gpsStartInput);
            this.addTextEl(timeIdx,'gpsStopInput',  this.gpsStopInput);
            this.addTextEl(timeIdx,'utcStartInput', this.utcStartInput);
            this.addTextEl(timeIdx,'utcStopInput',  this.utcStopInput);
            this.addTextEl(timeIdx,'commentInput',  this.commentInput);
            
            this.addBoolEl(timeIdx,'singleTimeRB',  this.singleTimeRB);
            this.addBoolEl(timeIdx,'timeListRB',    this.timeListRB);
            if (~isempty(this.timeList))
                ntimes = this.timeList.ntimes;
                if (ntimes > 0)
                    timeListElement = this.docNode.createElement('TimeList');
                    this.addIntEl(timeListElement,'ntimes', ntimes);
                    
                    for idx=1:ntimes
                        timeInterval = this.timeList.t(idx);
                        timeIntervalElement = this.docNode.createElement('TimeInterval');
                        this.addIntEl(timeIntervalElement,'startgps',timeInterval.startgps);
                        this.addIntEl(timeIntervalElement,'stopgps', timeInterval.stopgps);
                        if (~isempty(timeInterval.comment))
                            this.addTextEl(timeIntervalElement, 'comment', timeInterval.comment);
                        end
                       
                        timeListElement.appendChild(timeIntervalElement);
                    end
                    
                    timeIdx.appendChild(timeListElement);
                end
            end
            
            
            root.appendChild(timeIdx);
        end
        
        function addChannelSelectPanel(this, root)
            % Add all saved parameters relating to the Channel Selection panel
            % root - node to which we append a single node containing our
            %    parmeters
            
           chan = this.docNode.createElement('ChannelSelect');
           this.addTextEl(chan, 'channelSearchTxt', this.channelSearchTxt);
          
           this.addStrListEl(chan, 'channelList', this.channelList);

           root.appendChild(chan);
        end
        
        %----------------
        % Methods to create DOM Elements of different types
        
        function addTextEl(this, parent, name, value)
            % Create and add a new Text Node to the parent element
            % parent - existing element
            % name - name of new child
            % value - string: value of new child
            % attribute of type='string' is automatic
            
            el = this.docNode.createElement(name);
            el.appendChild(this.docNode.createTextNode(value));
            el.setAttribute('type','string');
            parent.appendChild(el);
        end
        
        function addBoolEl(this, parent, name, value)
            % Create and add a new True/False Node to the parent element
            % parent - existing element
            % name - name of new child
            % value - string: value of new child
            % attribute of type='boolean' is automatic
            
            el = this.docNode.createElement(name);
            v='false';
            if (value)
                v='true';
            end
            el.appendChild(this.docNode.createTextNode(v));
            el.setAttribute('type','boolean');
            parent.appendChild(el);
        end
        
        function addIntEl(this, parent, name, value)
            % Create and add a new integer Node to the parent element
            % parent - existing element
            % name - name of new child
            % value - string: value of new child
            % attribute of type='boolean' is automatic
            
            el = this.docNode.createElement(name);
            v=sprintf('%d',value);
            
            el.appendChild(this.docNode.createTextNode(v));
            el.setAttribute('type','integer');
            parent.appendChild(el);
        end
        
        function addStrListEl(this, parent, name, value)
            % Create and add a new String List Node to the parent element
            % parent - existing element
            % name - name of new child
            % value - string: value of new child
            % attribute of type='stringList' is automatic
            
            if (iscell(value))
                el = this.docNode.createElement(name);  % the list

                name2 = [char(name) '-str'];
                n = size(value);
                for i=1:n
                    el2= this.docNode.createElement(name2); % the strings in the list
                    el2.appendChild(this.docNode.createTextNode(value{i}));
                    el.appendChild(el2);
                end

                el.setAttribute('type','stringList');
                parent.appendChild(el);
            end
        end
        %----------------------------
        % Methods to load this object from an XML file
        
        function digestXml(this)
            % having read and parsed our saved file into docNode this
            % loads our properties
            
            val = this.getStringEl(this.doc,'name');
            if (~isempty(val))
                this.cname = val;
            end
            
            val = this.getStringEl(this.doc,'description');
            if (~isempty(val))
                this.description = val;
            end
            
            servNode = this.doc.getElementsByTagName('Server');
            this.loadServer(servNode);
            
            timeIdxNode = this.doc.getElementsByTagName('TimeSettings');
            this.loadTimeIndex(timeIdxNode);

            chanNode = this.doc.getElementsByTagName('ChannelSelect');
            this.loadChannelSelect(chanNode);

        end
        
        function loadServer(this,serv)
            % we are called with an array of server nodes fill the Server
            % section of properties with values overriding any duplicates
            
            for k=0:serv.getLength-1
                srv = serv.item(k);
                
                val = this.getStringEl(srv,'dvmode');
                if(~isempty(val))
                   this.dvmode=val;
                end
               
                val = this.getStringEl(srv,'gd_dataType');
                if(~isempty(val))
                    this.gd_dataType     = val;
                end
               
                val = this.getStringEl(srv,'server');
                if(~isempty(val))
                    this.server          = val;
                end
               
                val = this.getStringEl(srv,'port');
                if(~isempty(val))
                    this.port            = val;
                end
               
                val = this.getStringEl(srv,'rdsLevel');
                if(~isempty(val))
                    this.rdsLevel        = val;
                end
               
                val = this.getStringEl(srv,'calVersion');
                if(~isempty(val))
                    this.calVersion      = val;
                end
               
                val = this.getStringEl(srv,'gdStat');
                if(~isempty(val))
                    this.gdStat          = val;
                end
               

            end
        end
        
        function loadTimeIndex(this, timeIdxNode)
            % Called with an array of Time Index nodes, fill the
            % appropriate sections of our properties with values,
            % overriding any duplicates
            
            for k=0: timeIdxNode.getLength-1
                tidx = timeIdxNode.item(k);
                
                val = this.getStringEl(tidx,'timeInputMode');
                if(~isempty(val))
                    this.timeInputMode           = val;
                end
 
                val = this.getStringEl(tidx,'gpsStartInput');
                if(~isempty(val))
                    this.gpsStartInput           = val;
                end
 
                val = this.getStringEl(tidx,'gpsStopInput');
                if(~isempty(val))
                    this.gpsStopInput           = val;
                end
 
                val = this.getStringEl(tidx,'utcStartInput');
                if(~isempty(val))
                    this.utcStartInput           = val;
                end
 
                val = this.getStringEl(tidx,'utcStopInput');
                if(~isempty(val))
                    this.utcStopInput           = val;
                end
 
                val = this.getStringEl(tidx,'commentInput');
                if(~isempty(val))
                    this.commentInput           = val;
                end
                val = this.getBoolEl(tidx,'singleTimeRB');
                if(isempty(val))
                    val = 0;
                end
                this.singleTimeRB  = val;
                
                val = this.getBoolEl(tidx,'timeListRB');
                if(isempty(val) | this.singleTimeRB)
                    % as a radio button only one can be set so take the
                    % first true one
                    val = 0;
                end
                this.timeListRB  = val;
                
                %make sure one of the radio buttons is set
                if (~this.singleTimeRB & ~this.timeListRB)
                    this.singleTimeRB = 1;
                end
                
                timeListEls = tidx.getElementsByTagName('TimeList');
                
           
                for tidx=0: timeListEls.getLength-1
                    tle = timeListEls.item(tidx);
                    ntimes = this.getIntEl(tle,'ntimes');
                    intervalEls = tle.getElementsByTagName('TimeInterval');
                    nt = intervalEls.getLength;
                    if (nt ~= ntimes)
                        erMsg = ['Inconsistnecy in number of time intervals in [' this.cname '] configuration'];
                        disp(ermsg);
                    end
                    ntimes = nt;
                    for i=0:ntimes-1
                        intvEl = intervalEls.item(i);
                        gstrt = this.getIntEl(intvEl,'startgps');
                        gstop = this.getIntEl(intvEl, 'stopgps');
                        cmnt = this.getStringEl(intvEl,'comment');
                        ti(i+1) = struct('startgps',gstrt, 'stopgps', gstop, 'comment',cmnt);
                    end
                    this.timeList = struct('ntimes',ntimes,'t',ti);
                end

            end
        end
        
        function loadChannelSelect(this, chan)
            % Called with an array of channelSelect nodes fill the
            % appropriate section of properties with values
            % overriding any duplicates
            
            for k=0:chan.getLength-1
                chn = chan.item(k);
                
                val = this.getStringEl(chn,'channelSearchTxt');
                if(~isempty(val))
                    this.channelSearchTxt  = val;
                end
                 
                val = this.getStrListEl(chn,'channelList');
                if(~isempty(val))
                    this.channelList  = val;
                end
                
            end
        end
        
        %-----------
        % Methods to extract values from XML File
        
        function val = getStringEl(this, node, tag)
            % find the named tag in the node and get the string value
            val = '';
            try
                tagList = node.getElementsByTagName(tag);
                if tagList.getLength > 0
                    myTag=tagList.item(0);
                    c = myTag.getFirstChild;
                    if (~isempty(c))
                        val = char(c.getData);
                    end
                end
            catch er
                error('Error getting tag: %s, %s', tag, er.message);
            end
        end
        
        function val = getBoolEl(this, node, tag)
            % find the named tag in the node and get the true/false value
            val = false;
            try
                tagList = node.getElementsByTagName(tag);
                if tagList.getLength > 0
                    myTag=tagList.item(0);
                    c = myTag.getFirstChild;
                    str = char(c.getData);
                    val = strcmpi(str,'true');
                end
            catch er
                error('Error getting tag: %s, %s', tag, er.message);
            end
        end
        
        function val = getIntEl(this, node, tag)
            % find the named tag in the node and get the true/false value
            val = false;
            try
                tagList = node.getElementsByTagName(tag);
                if tagList.getLength > 0
                    myTag=tagList.item(0);
                    c = myTag.getFirstChild;
                    str = char(c.getData);
                    val = str2num(str);
                end
            catch er
                error('Error getting tag: %s, %s', tag, er.message);
            end
        end
        
        function val = getStrListEl(this, node, tag)
            % find the named tag in the node and get the string value
            val = cell(0,1);
            try
                tagList = node.getElementsByTagName(tag);
                if tagList.getLength > 0
                    myTag=tagList.item(0);
                    ctag = [char(tag) '-str'];
                    substrList = myTag.getElementsByTagName(ctag);
                    n = substrList.getLength;
                    val = cell(n,1);
                    for idx =0:n-1
                        subTag = substrList.item(idx);
                        c = subTag.getFirstChild;
                        str = char(c.getData);
                        val{idx+1} = str;
                    end
                    val=char(val);   % we need it to be a char array
                end
            catch er
                error('Error getting tag: %s, %s', tag, er.message);
            end
        end
        % ----------------------
        % Methods used to apply our values to the GUI
        
        function applyServer(this,handles)
            % Apply the settings from the server section to the GUI widgets
            
            this.setDropDown(handles.dvmode,this.dvmode);
            this.setDropDown(handles.gd_dataTypeSelect,this.gd_dataType);

            set(handles.gd_serverInputTxt,  'String', this.server);
            set(handles.gd_portInputTxt,    'String', this.port);
            set(handles.gd_rdslevel,        'String', this.rdsLevel);
            set(handles.gd_calversion,      'String', this.calVersion);
            
            this.setDropDown(handles.gd_stat,this.gdStat);
        end
        
        function applyTimeIndexPanel(this, handles)
            % Apply settings from the time Index panel to the GUI
            % this is more complicated than most of the others because
            % a) there are 2 overlaid panels depending on UTC/GPS
            % b) calculations are done to produce duration
            % c) List of times are possible
            
            this.setDropDown(handles.timeInputMode,this.timeInputMode);
            
            set(handles.commentInput,   'String', this.commentInput);
            
            set(handles.singleTimeRB,   'Value',  this.singleTimeRB);
            set(handles.timeListRB,     'Value',  this.timeListRB);
            
            %this panel is actually 2 overlaid panels display the right one
            ldv_settimepanel(handles);
            timemode  = ldv_getselectionbox(handles.timeInputMode);

            % do the conversions and calculate duration
            switch timemode
              case 'UTC'
                  
                set(handles.utcStartInput,  'String', this.utcStartInput);
                set(handles.utcStopInput,   'String', this.utcStopInput);
                ldv_utcstart(handles);
                ldv_utcstop(handles);
                
              case 'GPS'

                set(handles.gpsStartInput,  'String', this.gpsStartInput);
                set(handles.gpsStopInput,   'String', this.gpsStopInput);
                ldv_gpsstart(handles);
                ldv_gpsstop(handles);

              otherwise
                error('### unknown time input mode');
            end
            ldv_setdurationdisp(handles);
            ntimes = 0;
            if ~isempty(this.timeList)
                setappdata(handles.main,'times',this.timeList);
                ntimes = this.timeList.ntimes;
            end
            set(handles.ntimes_display,'String',sprintf('%d',ntimes));
        end

        function applyChannelList(this,handles)
            % Apply settings from the channel list section to the GUI
            % widgets
            
            set(handles.channelSearchTxt, 'String', this.channelSearchTxt);
            
            set(handles.channelList, 'Value', [1]);
            set(handles.channelList, 'ListboxTop', [1]);
            set(handles.channelList, 'String', this.channelList);
        end
        
    end % protected methods
end

