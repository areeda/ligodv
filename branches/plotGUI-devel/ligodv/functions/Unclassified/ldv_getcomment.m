function comment = ldv_getcomment(handles)

% LDV_GETCOMMENT get the comment entered in the times comment field.
% 
% M Hewitson 26-07-06
% 
% $Id$

comment = get(handles.commentInput, 'String');

% END