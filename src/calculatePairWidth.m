function values = calculatePairWidth(width)
%CALULATEPAIRWIDTH Outputs the scalars for the stereo width of the mic
%pair.
%   The stereo width is a value between 0 and 1 where 0 is both mics
%   centered and 1 is both mics hard-panned left and right. This function
%   takes the width number and outputs the LR scalar values for the
%   microphones to be panned. Since the microphones are mirror images of
%   each other, the left microphone is the output, and the right microphone
%   simply takes the same values in the reverse order.

val = (width * pi/4) + pi/4;
L = cos(val);
R = sin(val);

values = [L R];

end

