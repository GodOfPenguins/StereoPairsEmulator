function [scalar, time] = processMains(distance, sCoord, splay, p, c, isEnabled)
%PROCESSMAINS Performs the conversions and processing for the main mic
%array.
%   Takes in the raw values for the main microphone array and returns the
%   time and scalar values after any necessary conversion. Outputs
%   appropriate values if pair is not enabled.

if isEnabled == true
    d = cm2M(distance);
    vals = getMicPair(d, sCoord, splay, p, c);
else
    vals = [1000 0];
end

time = vals(1);
scalar = vals(2);



end

