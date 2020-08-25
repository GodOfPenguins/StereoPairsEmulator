function vals = getLevelDistanceAdjustmentScalars(type,strength,dArray)
%GETLEVELDISTANCEADJUSTMENTSCALARS Calcualtes the level adjustment scalars
%for the vMic array.
%   Takes in the type of level adjustment and the level adjustment strength
%   based on the UI enum values, and the array of vMic distances. It then
%   calculates the amount of damping per distance based on the input
%   parameters.

if type == 0 % Quick check to see if we are actually using this parameter.
    vals = [1 1 1 1 1];
else
    switch(strength)
        case 0 % -6dB
            s = 20;
        case 1 % -3dB
            s = 10;
        case 2 % -1.5dB
            s = 5;
        otherwise
            s = 10;
    end
    switch (type)
        case 1 % Flanks only
            vals = dampingFlanks(dArray, s);
        case 2 % Pairwise
            vals = dampingPairwise(dArray, s);
        case 3 % Full array
            vals = dampingFullArray(dArray, s);
        otherwise
            vals = [1 1 1 1 1];
    end
end
end

