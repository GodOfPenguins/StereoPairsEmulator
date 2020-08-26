function vals = getLevelDistanceAdjustmentScalars(type,strength,dArray, s)
%GETLEVELDISTANCEADJUSTMENTSCALARS Calcualtes the level adjustment scalars
%for the vMic array.
%   Takes in the type of level adjustment and the level adjustment strength
%   based on the UI enum values, and the array of vMic distances. It then
%   calculates the amount of damping per distance based on the input
%   parameters.

d = getMicDistanceArray(dArray, s);
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
    case 'None' % None
        vals = [1 1 1 1 1];
    case 'Flanks Only' % Flanks only
        vals = dampingFlanks(d, s);
    case 'Pairwise' % Pairwise
        vals = dampingPairwise(d, s);
    case 'Full Array' % Full array
        vals = dampingFullArray(d, s);
    otherwise
        vals = [1 1 1 1 1];
end
end

