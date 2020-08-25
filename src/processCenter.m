function [scalar, time] = processCenter(distance, s, p, c, isEnabled)
%PROCESSCENTER Returns the values for the center with appropriate
%conversions
%   Takes in the raw values for the center microphone and returns the
%   time and scalar values after any necessary conversion. Outputs
%   appropriate values if pair is not enabled.

if isEnabled == true
    d = cm2M(distance);
    vals = getCenterMic(d, s, p, c);
else
    vals = [1000 ; 0];
end

scalar = vals(2);
time = vals(1);

end

