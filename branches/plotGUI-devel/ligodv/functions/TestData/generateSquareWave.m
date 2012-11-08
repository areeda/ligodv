function x = generateSquareWave( param )
%GENERATESQUAREWAVE Summary of this function goes here
%   Detailed explanation goes here

    x = generateSine(param);
    for i=1:param.nPts
        if (x(i) > 0)
            x(i) = 1;
        else
            x(i) = 0;
        end
    end
    
    
end

