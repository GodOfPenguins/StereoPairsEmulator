function time = getMicTime(mCoord, sCoord, c)
%GETMICTIME Gets the time value for the mic
%   Takes the mic and source coordinate values and the speed of sound and
%   returns the microphone's time-domain value in milliseconds. 

d = getDistance(mCoord, sCoord);
time = distanceTimeConversion(d, c);

end

