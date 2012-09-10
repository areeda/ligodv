function fdlg_viewFilters(handles)

% FDLG_VIEWFILTERS plot response of selected filters for the chosen sample
% rate.
% 
% M Hewitson 09-08-06
% 
% $Id$
% 

% get selected filters
fidx    = get(handles.fdlg_filterList, 'Value');
filters = getappdata(handles.main, 'filters');
combine = get(handles.fdlg_combineFilters, 'Value');
% get sample rate
fs = str2double(ldv_getselectionbox(handles.fdlg_fsSelect));

%declare counting variables
countTotal = 0;
count = 1;

%build total filters selected
for f=fidx
    countTotal = 1 + countTotal;
end


%if (combine == 0)
% plot each selected filter
 for f=fidx 
  % build this filter
  try 
      ldv_buildIIRFilter(filters.filt(f), fs);
  catch e
      msg = 'No Filters to view';
      mymsg = sprintf(msg);
      mb = msgbox(mymsg, 'Input Error', 'error');
      waitfor(mb);
  end
  fobj = ldv_buildIIRFilter(filters.filt(f), fs);

  buildTitle{count} = ldv_buildFilterTitle( fobj.name , filters.filt , f );
% plot response
  Nf   = 1000;
  freq = logspace(log10(1/Nf), log10(fs/2), Nf);
  
%plot all filters seperately
  if (combine == 0)
      
    ldv_iirfiltresp(freq, fobj, buildTitle);
    
%plot all filters together   
  else
  
    %obtain total responses
    [fd, dresp] = ldv_iirfiltresp(freq, fobj, filters.filt(f));
    
    if (count > 1)
        drespTotal = dresp .*  drespTotal;
      
    else
        drespTotal = dresp;

    end

    % plot response
    if ( count == countTotal )  
       fdlg_viewMultipleFilters( drespTotal, freq, buildTitle );
    end
    count = count + 1;
   
  end
 end

 
 
 

