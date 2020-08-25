function vals = distanceDamping(dArray, strength)
%DISTANCEDAMPING Calculates damping with distance.
%   Takes the input distances and the damping strength and calculates the
%   damping magnitude scalars for each distance.

d = min(dArray) ./ dArray;
db = strength .* log10(d);
vals = db2mag(db);

end

