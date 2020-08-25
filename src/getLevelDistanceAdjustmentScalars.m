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
    s;
    switch(strength)
        case 0 % -6dB
            s = db2mag(-6);
        case 1 % -3dB
            s = db2mag(-3);
        case 2 % -1.5dB
            s = db2mag(-1.5);
        otherwise
            s = db2mag(-6);
    end
    
    
    
end
end

