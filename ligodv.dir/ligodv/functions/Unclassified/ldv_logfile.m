function ldv_logfile

% LDV_LOGFILE create a logfile with <timestamp computer user>.
% 
% J Smith 2/8/08
% 
% $Id$

% logfilepath = '/cvs/cds/lho/logs/'; % for LHO
logfilepath = '';

fnm = [logfilepath,'ligodv.log'];
tmstmp = datestr(now,0);

if isunix
    [status, hostname] = unix('hostname');
    [status, user] = unix('whoami');
else
    hostname = 'unknown';
    user = computer;
end

fid = fopen(fnm,'a');
if ~fid==-1; % check that file is readable
    fprintf(fid, '%s\t%s\t%s\n', strtrim(tmstmp), strtrim(hostname), strtrim(user));
    fclose(fid);
end