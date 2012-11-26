function generateTestData( handles )
%GENERATETESTDATA process the Test Data Dialog and create a new dataset
%   Detailed explanation goes here

    disp('generating test data');
    % build parameter structure from Dialog text
    param.fs = getVal(handles.fsTxt);
    param.duration = getVal(handles.durTxt);
    param.nPts = param.fs * param.duration;
    param.freq = getVal(handles.sigFrqTxt);
    param.nHarmonics = getVal(handles.harmonicTxt) + 1;
    param.decay =  get(handles.decayCB,'Value');
    param.q = getVal(handles.qVal);
    
    name='oops';
    % generate specified data
    if (get(handles.chirpRB,'Value'))
        x = generateChirp(param);
        name='Chirp';
    end
    
    if (get(handles.gaussRB,'Value'))
        x = generateGaussianNoise(param);
        name='Gaussian_noise';
    end
    
    if (get(handles.impulseRB,'Value'))
        x = generateImpulse(param);
        name = 'Impulse';
    end
    
    if (get(handles.sawtoothRB,'Value'))
        x = generateSawtooth(param);
        name = 'Sawtooth';
    end
    
    if (get(handles.sineRB,'Value'))
        x = generateSine(param);
        name = 'Sine';
    end
    
%     if (get(handles.sineDecayRB,'Value'))
%         x = generateDampedSine(param);
%         name = 'Damped Sine';
%     end
    
    if (get(handles.squareWaveRB,'Value'))
        x = generateSquareWave(param);
        name='Square_wave';
    end
    
    if (get(handles.whiteNoiseRB,'Value'))
        x = generateWhiteNoise(param);
        name = 'White_noise';
    end

    if (get(handles.sineGaussRB,'Value'))
        x = generateSineGauss(param);
        name = 'Sine Gaussian';
    end
    
    strtTime = ldv_getlatest(handles);  % current GPS time
    obj = DataObject();
    obj.setChanName(name);
    obj.setServer('localhost');
    obj.setType('generated');
    obj.setFs(param.fs);
    obj.setStart(strtTime);
    obj.setStop(strtTime + param.duration);
    obj.setX(x);
    
    newobj = obj.getDataPoolObj();
    add1toDataPool(handles.ldvHandles,newobj);
end

function val = getVal(h)
% return the numeric value in the text box or zero if it's not a number
    txt = get(h,'String');
    if ( regexp(txt,'[+\-]?[\d\.]+'))
        val = str2double(txt);
    else
        val = 0;
    end
end

