function fdlg_inputPZAdd(handles)

% FDLG_INPUTPZADD add a pole/zero filter to the list.
%
% J Smith 5/8/08.
% Started by M Hewitson 13-08-06.
%
% $Id$
%

% get existing filters
filters = getappdata(handles.main, 'filters');

% get ftype, poles, zeros and gain as strings
pstr = dv_strs2cells(get(handles.fdlg_inputPZpoles, 'String'));
zstr = dv_strs2cells(get(handles.fdlg_inputPZzeros, 'String'));
gstr = dv_strs2cells(get(handles.fdlg_inputPZgain, 'String'));

% Preallocate
tf.p      = [];
tf.z      = [];
tf.npoles = 0;
tf.nzeros = 0;
tf.g      = 1;

% Convert strings to values
if ~strcmp(pstr,'0,0')
    % go through poles
    for j=1:length(pstr)
        % parse this line
        [p,q] = strtok(char(pstr(j)), ',');
        if isempty(q)
            q = ',0';
        end
        % set tf element
        tf.npoles         = tf.npoles + 1;
        tf.p(tf.npoles).f = str2double(deblank(p));
        tf.p(tf.npoles).q = str2double(deblank(strrep(q, ',', '')));
    end
end

if ~strcmp(zstr,'0,0')
    % go through zeros
    for j=1:length(zstr)
        % parse this line
        [z,q] = strtok(char(zstr(j)), ',');
        if isempty(q)
            q = ',0';
        end
        % set tf element
        tf.nzeros         = tf.nzeros + 1;
        tf.z(tf.nzeros).f = str2double(deblank(z));
        tf.z(tf.nzeros).q = str2double(deblank(strrep(q, ',', '')));
    end
end

tf.g = str2double(gstr);

% add filter description
filters.nfilts = filters.nfilts + 1;
filters.filt(filters.nfilts).type  = char('pzmodel');
filters.filt(filters.nfilts).npoles = tf.npoles;
filters.filt(filters.nfilts).nzeros = tf.nzeros;
filters.filt(filters.nfilts).poles = tf.p;
filters.filt(filters.nfilts).zeros = tf.z;
filters.filt(filters.nfilts).gain  = tf.g;

% add to filter structure
setappdata(handles.main, 'filters', filters);

% rebuild filter list
fdlg_setFilterList(handles);

% END
