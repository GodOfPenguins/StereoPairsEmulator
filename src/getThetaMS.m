% This function finds how off-axis the source is from the microphone
% (theta) by using the four-quadrant inverse tangent function and the
% cartesian coordinate values for the virtual microphone and source's
% positions on the virtual sound stage.
function theta = getThetaMS(micPosXY, sourcePosXY)
    x = micPosXY(1) - sourcePosXY(1);
    y = micPosXY(2) - sourcePosXY(1);
    theta = atan2(y, x);
end