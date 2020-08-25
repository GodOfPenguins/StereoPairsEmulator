function [scalarArray,timeArray] = updateMicArray(dArray, splayArray, pArray, s, c, isEnabledArray, sr)
%UPDATEMICARRAY Gets the updated values for the microphone array.
%   Takes in arrays and positional data for the microphones and calculates
%   the transfer functions for the entire microphone set-up and returns the scalar and time
%   values as arrays. Also converts the time to samples.

% Unsure if this is necessary, but just to be safe...
vArray = [0 0 0 0 0];
tArray = [0 0 0 0 0];

% Get the mic arrays
[vArray(1:2), tArray(1:2)] = processMains(dArray(1), s, splayArray(1), pArray(1), c, isEnabledArray(1));
[vArray(3:4), tArray(3:4)] = processFlanks(dArray(2), s, splayArray(2), pArray(2), c, isEnabledArray(2));
[vArray(5), tArray(5)] = processCenter(dArray(3), s, pArray(3), c, isEnabledArray(3));

scalarArray = vArray;
timeArray = sec2Samps(tArray, sr);

end

