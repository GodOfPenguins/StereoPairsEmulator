function pos = sourceCartesianCoordinates(az, distance)
    theta = az * (pi/180);
    basis = [cos(theta), sin(theta)];
    pos = distance * basis;
end