function values = getMicArrayStereoOutputScalars(vMicArray, panningArray, mixLevelArray)
%GETMICARRAYSTEREOOUTPUTSCALARS Takes in the vMic scalars and the mixbus
%panning and level settings and calculates the final stereo output values
%for each microphone.
%   Takes in the virtual microphone scalars, the panning scalars and the
%   mix gain scalars and calculates the final values needed for the stereo
%   output for each mic for the left and right stereo output channels.
%   Output is a 2x5 matrix with the rows as the L and R scalars and the
%   microphones by column.

mix = [mixLevelArray(1) mixLevelArray(1) mixLevelArray(2) mixLevelArray(2) mixLevelArray(3)];
mix = mix .* vMicArray;
pan = [panningArray(1) panningArray(2) panningArray(3) panningArray(4) sin(pi/4);...
       panningArray(2) panningArray(1) panningArray(4) panningArray(3) sin(pi/4)];

L = mix .* pan(1,:);
R = mix .* pan(2,:);

values = [L;R];
end

