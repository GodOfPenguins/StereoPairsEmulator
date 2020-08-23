function [aL, aR] = splayConversion(angle)
    rad = deg2rad(angle) + (pi/2);
    splay = rad / 2;
    aL = splay;
    aR = -splay;
end