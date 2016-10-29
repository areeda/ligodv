function ldv_setdobjinfo(handles)

% LDV_SETDOBJINFO set the information panel for a data object.
% 
% M Hewitson 27-07-06
% 
% $Id$
% 

% get selected data objects
objsidx = ldv_getselecteddobjs(handles);
dobjs   = getappdata(handles.main, 'dobjs');

if dobjs.nobjs == 0
  set(handles.dobjInfoTxt, 'HorizontalAlignment', 'left'); 
  set(handles.dobjInfoTxt, 'String', '');
  return;
end

if length(objsidx) == 1
  set(handles.dobjInfoTxt, 'HorizontalAlignment', 'left'); 
  obj = dobjs.objs(objsidx);
  
  % then we fill info panel with details
  set(handles.dobjInfoPanel, 'Title', [sprintf('%02d',obj.id) ': ' obj.channel]);
  
  % duration
  dur    = obj.stopgps - obj.startgps;
  durstr = ldv_secs2timestr(dur);
  %------------------------------------------------------------------------------------------------------------------------------------
  % Pre-processing info
  if((obj.preproc.heterodyneOn == 0) && (obj.preproc.whitening == 0) && (obj.preproc.resample.R == 1) && (obj.preproc.math.cmd == 'u'))
    preProcessOnOff = sprintf('   OFF\n');
  else
    %heterodyne
    if(obj.preproc.heterodyneOn == 1)
       heterodyneOnOff = sprintf('   Heterodyne: (@ %2.2f Hz)\n', obj.preproc.f0);
    else
       heterodyneOnOff = sprintf('   Heterodyne: OFF\n');
    end
    %whitening
    if(obj.preproc.whitening == 1)
       whitenOnOff = sprintf('   Whiten Data: ON\n');
    else
       whitenOnOff = sprintf('   Whiten Data: OFF\n');
    end
    %resmapleing
    if(obj.preproc.resample.R == 1)
       resampleOnOff = sprintf('   Resample Factor: OFF\n');
    else
       resampleOnOff = sprintf('   Resample Factor: %d\n', obj.preproc.resample.R) ;
    end  
    %math
    if(obj.preproc.math.cmd == 'u')
       mathOnOff = sprintf('   Math: Off\n');
    else
       mathOnOff = sprintf('   Math: %s\n\n', obj.preproc.math.cmd);
    end  
    preProcessOnOff = [heterodyneOnOff , whitenOnOff , resampleOnOff , mathOnOff];
  end
  %------------------------------------------------------------------------------------------------------------------------------------
  %Post-Processing
  if((obj.data.includingPrime == 0) && (obj.filters.nfilts == 0) && (obj.filters.apply == 0))
    postProcessingOnOff = sprintf('   OFF\n');
  else
    %Prime data
    if(obj.data.includingPrime == 0)
        primeDataOnOff = sprintf('   Prime Data = OFF\n');
    else
        primeDataOnOff = sprintf('   Prime Data = %ds\n', obj.data.includingPrime);
    end
    %Number of Filters
    switch(obj.filters.nfilts)
        case 0
            numFiltsOnOff = sprintf('   No Filters Active');
        case 1
            numFiltsOnOff = sprintf('   %d Filter is Active', obj.filters.nfilts);
        otherwise
            numFiltsOnOff = sprintf('   %d Filters are Active', obj.filters.nfilts);
    end
    %Filters Applied?
    if(obj.filters.apply == 1)  
        filtApplyOnOff = sprintf('   Apply Filters = ON\n');             
    else         
        filtApplyOnOff = sprintf('   Apply Filters = OFF\n');
    end
    postProcessingOnOff = [primeDataOnOff, filtApplyOnOff, numFiltsOnOff];
  end
  %------------------------------------------------------------------------------------------------------------------------------------
  % format info string
  infostr = [ ...            
              sprintf('Data info\n')...     
              sprintf('   start: %s [%d]\n', ldv_gps2utc(obj.startgps), obj.startgps) ...
              sprintf('   stop: %s [%d]\n', ldv_gps2utc(obj.stopgps), obj.stopgps) ...
              sprintf('   duration: %s\n', durstr) ...
              sprintf('   %s @ %dHz [%d samples]\n', obj.source.type, obj.data.fs, length(obj.data.x)) ...    
              sprintf('   server: %s:%d\n',...
                        obj.source.server, obj.source.port) ...
              sprintf('   Units: %s, Amplitude (%s)\n\n', obj.data.unitX, obj.data.unitY) ...
              sprintf('Pre-processing:\n') ...
              preProcessOnOff...
              sprintf('Post-processing:\n') ...
              postProcessingOnOff...
            ];   
    
  % enable buttons
  set(handles.dobjInfoEditFiltersBtn, 'Enable', 'on');
  
  
else
  % we fill with -
  set(handles.dobjInfoTxt, 'HorizontalAlignment', 'center');
  infostr = 'Multiple Filters Are Selected';      
  
  % disable buttons
  set(handles.dobjInfoEditFiltersBtn, 'Enable', 'off');
  
end

set(handles.dobjInfoTxt, 'String', infostr);


end



% END