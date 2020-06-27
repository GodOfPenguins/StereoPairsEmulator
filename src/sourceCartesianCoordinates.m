function pos = sourceCartesianCoordinates(theta, distance)
    basis = [cos(theta), sin(theta)];
    pos = distance * basis;
end