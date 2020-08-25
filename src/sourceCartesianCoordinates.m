function pos = sourceCartesianCoordinates(az, distance)
% Converts the source angle and distance to cartesian coordinates.
%   Takes in the angle from center in degrees and the distance in meters that the
%   source is and converts it to x,y cartesian coordinates.
    
    % Convert the angular deflection into radians of rotation
    theta = (az * (pi/180)) + (pi/2);
    % Get Coordinates
    basis = [cos(theta), sin(theta)];
    pos = distance * basis;
end