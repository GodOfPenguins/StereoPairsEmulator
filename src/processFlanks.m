function [scalar, time] = processFlanks(d, sCoord, splay, p, c, isEnabled)
%PROCESSFLANKS Performs the conversions and processing for the flanks mic
%array.
%   Takes in the raw values for the flank microphone array and returns the
%   time and scalar values after any necessary conversion. Outputs
%   appropriate values if pair is not enabled.

if isEnabled == true
    vals = getMicPair(d, sCoord, splay, p, c);
else
    vals = [1000 1000; 0 0];
end

time = [vals(1), vals(3)];
scalar = [vals(2), vals(4)];

end

