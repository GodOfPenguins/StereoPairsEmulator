function vals = getLevelDistanceAdjustmentScalars(type,strength,dArray)
%GETLEVELDISTANCEADJUSTMENTSCALARS Calcualtes the level adjustment scalars
%for the vMic array.
%   Takes in the type of level adjustment and the level adjustment strength
%   based on the UI enum values, and the array of vMic distances. It then
%   calculates the amount of damping per distance based on the input
%   parameters.

if type == 'None' % Quick check to see if we are actually using this parameter.
    vals = [1 1 1 1 1];
else
    switch(strength)
        case '-6' % -6dB
            s = 20;
        case '-3' % -3dB
            s = 10;
        case '1.5' % -1.5dB
            s = 5;
        otherwise
            s = 10;
    end
    switch (type)
        case 'Flanks Only' % Flanks only
            vals = dampingFlanks(dArray, s);
        case 'Pairwise' % Pairwise
            vals = dampingPairwise(dArray, s);
        case 'Full Array' % Full array
            vals = dampingFullArray(dArray, s);
        otherwise
            vals = [1 1 1 1 1];
    end
end
end

