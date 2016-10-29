function ldv_dataProductExport(dvout)

% LDV_DATAPRODUCTEXPORT export data products to workspace.
%
% J Smith 12/11/07
%
% $Id$

% check current workspace variables
basename = 'ex_prods';
ex = 0;
n  = [];
vars = evalin('base', 'who');
for j=1:length(vars)
    v = char(vars{j});
    if strncmp(basename, v, length(basename)) == 1
        % get the number
        n = [n str2num(v(end-1:end))];
    end
end

% increment
ex = max([n ex])+1;

ex_prods.objs  = dvout.obj;
ex_prods.type = dvout.type;

varname = sprintf('%s_%02d', basename, ex);
assignin('base', varname, ex_prods);

ldv_disp('*** Products exported as structure %s', varname);

% END