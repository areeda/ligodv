function ldv_yaxis(hfig, ylims)

% LDV_YAXIS sets the yaxis of all plots in all figures.
% 
% M Hewitson 06-09-06
% 
% $Id$
% 

if ~isempty(ylims)
  
  c = get(hfig, 'children');

  for k=1:length(c)

    t = get(c(k), 'Tag');
    if isempty(t)
      set(c(k), 'YLim', ylims);
    end

  end

end


% END