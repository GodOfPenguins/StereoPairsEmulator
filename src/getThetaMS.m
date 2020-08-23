% This function finds how off-axis the source is from the microphone
% (theta) by using the four-quadrant inverse tangent function and the
% cartesian coordinate values for the virtual microphone and source's
% positions on the virtual sound stage. The thetaM input should be in
% radians.
function thetaMS = getThetaMS(micPosXY, sourcePosXY, thetaM)
    x = sourcePosXY(1) - micPosXY(1);
    y = sourcePosXY(2) - micPosXY(2);
    thetaMS = atan2(y, x) - thetaM;
end