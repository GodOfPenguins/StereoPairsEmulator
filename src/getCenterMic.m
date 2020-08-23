function vals = getCenterMic(d, sCoord, p, c)
%GETCENTERMIC Returns the values for the center mic
%   Similar to getMicPair, but just for the one mic.

pos = [0 (d / 100)];
vals = getMicTransferFunction(pos, sCoord, pi/2, p, c);

end

