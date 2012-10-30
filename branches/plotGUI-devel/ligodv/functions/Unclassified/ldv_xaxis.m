function ldv_xaxis(hfig, xlims)

% LDV_XAXIS sets the xaxis of all plots in all figures.
% 
% M Hewitson 06-09-06
% 
% $Id$
% 

if ~isempty(xlims)
  
  c = get(hfig, 'children');

  for k=1:length(c)

    t = get(c(k), 'Tag');
    if isempty(t)
      set(c(k), 'XLim', xlims);
    end

  end

end


% END