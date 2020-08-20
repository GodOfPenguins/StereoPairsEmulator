function [time,mag] = getMicTransferFunction(mCoord, sCoord, p, c)
%GETMICTRANSFERFUNCTION Gets the time and amplitude scalars for the virtual
%microphone
%   This class takes in the microphone and source coordinate data, polar
%   pattern value, and speed of sound; and returns the time and magnitude
%   dispalcements for the virtual microphone.

time = getMicTime(mCoord, sCoord, c);
mag = getMicAmplitudeScalar(mCoord, sCoord, p);

end

