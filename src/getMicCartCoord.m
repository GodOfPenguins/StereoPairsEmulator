function pos = getMicCartCoord(distance, isCenter)
    if isCenter
        x = 0;
        y = distance;
    else
        x = distance;
        y = 0;
    end
    pos = [x,y];
end