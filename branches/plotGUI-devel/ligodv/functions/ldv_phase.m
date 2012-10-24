function phase = ldv_phase(resp)

% LDV_PHASE compute a phase vector for the complex response.
% 
% M Hewitson 10-08-06
% 
% $Id$
% 

phase = angle(resp)*180/pi;


% END