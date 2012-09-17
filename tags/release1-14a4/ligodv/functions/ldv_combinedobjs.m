function ldv_combinedobjs(handles)

% LDV_COMBINEDOBJS combine selected data objects using an arbitrary math
% string.
%
% J Smith 12/10/07
%
% $Id$
%

% get math string
mathstr = get(handles.combineObjsMathTxt, 'String');
if isempty(mathstr)
    error('Select at least two channels and enter a combine math string.')
else
    ldv_disp('*** Combining data objects with math: %s\n', mathstr)

    % get indices of selected data objects
    objsidx  = ldv_getselecteddobjs(handles);
    % load all data objects
    dobjs = getappdata(handles.main, 'dobjs');
    % keep track of starting dobjs since it gets overwritten by vector
    % matching
    dobjs_start = dobjs;

    % prepare output structure for combined objects
    combdobjs       = [];
    combdobjs.nobjs = 0;

    % set up a new object
    combdobjs.nobjs = combdobjs.nobjs+1;
    combdobjs.objs(combdobjs.nobjs) = dobjs.objs(objsidx(1));

    % check that sample rates are eqaual for the two vectors
    srN = [];
    for n=1:length(objsidx)
        srN = [srN dobjs.objs(objsidx(n)).data.fs];
    end
    % If sample rates are unequal, resample all higher sr objects to match
    % lower sr
    if ~isequal(mean(srN),srN(1))
        %error('!!! Sample rates not equal.')

        % find lowest sample rate and objs with higher sr than that
        fsnew = min(srN);
        lowsridx = min(find(srN==fsnew));
        highsridx = find(srN>fsnew);

        for n=1:length(highsridx)
            % downsample vector with higher SR
            [dobjs.objs(objsidx(lowsridx)).data.x, dobjs.objs(objsidx(highsridx(n))).data.x, fsnew] = ...
                ldv_matchvectors(dobjs.objs(objsidx(lowsridx)).data.x, fsnew,...
                dobjs.objs(objsidx(highsridx(n))).data.x, dobjs.objs(objsidx(highsridx(n))).data.fs);

            dobjs.objs(objsidx(highsridx(n))).data.fs = fsnew;
        end
    end

    % replace xn in math string with object(n)
    mathstrrep = mathstr;
    for n=1:length(objsidx)
        mathstrrep = strrep(mathstrrep, ['x',num2str(dobjs.objs(objsidx(n)).id)],...
            ['dobjs.objs(objsidx(',num2str(n),')).data.x']);
    end

    % combine objects using math
    eval(sprintf('combdobjs.objs(combdobjs.nobjs).data.x=%s;', mathstrrep));

    % make new channel name
    combdobjs.objs(combdobjs.nobjs).channel = [mathstr];

    % combdobjs.objs(combdobjs.nobjs).id = -objsidx;  % reset counter

    % add objects and reset list
    dobjs = ldv_dobjsunique(dobjs_start, combdobjs, handles);

    % set list of objects
    setappdata(handles.main, 'dobjs', dobjs);
    ldv_setnobjsdisplay(handles, dobjs);
    ldv_setdobjslist(handles, dobjs, objsidx);
end

% END