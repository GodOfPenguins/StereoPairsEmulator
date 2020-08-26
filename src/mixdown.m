function output = mixdown(signal,scalars)
%MIXDOWN Takes in the delayed audio frame and the 2x5 matrix of scalars and
%outputs the L and R audio mixdown.
%   The rows of the scalars matrix should be [L;R]. This multiplies the
%   input signal by the L and R scalars and then sums the mic audio
%   channels within each stereo channel together.

% Having issues with manipulating arrays in the class... unsure why.

L1 = signal(:,1) * scalars(1,1);
L2 = signal(:,2) * scalars(1,2);
L3 = signal(:,3) * scalars(1,3);
L4 = signal(:,4) * scalars(1,4);
L5 = signal(:,5) * scalars(1,5);

R1 = signal(:,1) * scalars(2,1);
R2 = signal(:,2) * scalars(2,2);
R3 = signal(:,3) * scalars(2,3);
R4 = signal(:,4) * scalars(2,4);
R5 = signal(:,5) * scalars(2,5);

L = L1 + L2 + L3 + L4 + L5;
R = R1 + R2 + R3 + R4 + R5;

output = [L,R];

end

