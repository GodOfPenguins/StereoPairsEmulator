function scalar = getMicAmplitudeScalar(mCoord, sCoord, thetaM, p)
%GETMICAMPLITUDESCALAR gets the amplitude scalar for a vMic
%   This function takes in the coordinates [x,y] of a virtual microphone and
%   the sound source along with a polar pattern and uses the
%   virtualMicrophone and getThetaMS classes to calculate the amplitude scalar.

theta = getThetaMS(mCoord, sCoord, thetaM);
scalar = virtualMicrophone(p, theta);

end

