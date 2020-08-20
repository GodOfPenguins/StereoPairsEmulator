function [posL, posR] = getMicCartCoord(distance)
%GETMICCARDCOORD converts a mic from a pair to cartesian coord
% This only works for the main/flanks. Make sure the distance is in m and
% not cm.

    d = distance / 2;
    xL = -d;
    xR = d;
    y = 0;
    
    posL = [xL y];
    posR = [xR, y];
end