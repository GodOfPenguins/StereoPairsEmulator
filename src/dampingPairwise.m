function vals = dampingPairwise(dArray, strength)
%DAMPINGPAIRWISE Calculates damping by distance per-mic-pair.
%   Divides the array into mains+center and flanks, and then calculates
%   damping with distance for each of the two groups separately.

dMC = [dArray(1) dArray(2) dArray(3)];
dF = [dArray(3) dArray(4)];

vMC = distanceDamping(dMC, strength);
vF = distanceDamping(dF, strength);

vals = [vMC(1:2) vF vMC(3)];

end

