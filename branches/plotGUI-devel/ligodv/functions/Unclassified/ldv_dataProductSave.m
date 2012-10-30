function ldv_dataProductSave(dvout)

% LDV_DATAPRODUCTSAVE save data products to mat file.
% 
% M Hewitson 06-09-06
% 
% $Id$
% 


% Get filename
[filename, pathname] = uiputfile('*.mat', 'MAT-file output');
outfilename = [pathname filename];
if ~isempty(outfilename)
  save(outfilename, 'dvout');
else
  error('### failed to get filename');
end


% END