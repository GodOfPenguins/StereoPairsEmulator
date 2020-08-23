function [aL, aR] = splayConversion(angle)
    splay  = deg2rad(angle) / 2;
    hpi = 1.57079632679;
    aL = hpi + splay;
    aR = hpi - splay;
end