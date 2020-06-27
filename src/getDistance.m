function d = getDistance(micPosXY, sourcePosXY)
    x = (sourcePosXY(1) - micPosXY(1))^2;
    y = (sourcePosXY(2) - micPosXY(2))^2;
    d = sqrt(x + y);
end