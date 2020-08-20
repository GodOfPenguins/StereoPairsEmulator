function pair = getMicPair(mDistance, sCoord, mSplay, p, c)
%GETMICPAIR Summary of this function goes here
%   Detailed explanation goes here

[posL, posR] = getMicCartCoord(mDistance);

[thetaL, thetaR] = splayConversion(mSplay);

mic1 = getMicTransferFunction(posL, sCoord, thetaL, p, c);
mic2 = getMicTransferFunction(posR, sCoord, thetaR, p, c);

pair = [mic1, mic2];

end

