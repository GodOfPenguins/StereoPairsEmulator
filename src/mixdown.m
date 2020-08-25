function output = mixdown(signal,scalars)
%MIXDOWN Takes in the delayed audio frame and the 2x5 matrix of scalars and
%outputs the L and R audio mixdown.
%   The rows of the scalars matrix should be [L;R]. This multiplies the
%   input signal by the L and R scalars and then sums the mic audio
%   channels within each stereo channel together.

audioL = signal .* scalars(1)
audioR = signal .* scalars(2)

L = sum(audioL,2);
R = sum(audioR,2);

output = [L,R];

end

