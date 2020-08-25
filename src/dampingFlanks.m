function vals = dampingFlanks(dArray,strength)
%DAMPINGFLANKS Applies distance damping to the flanking mics only.

dF = dArray(3:4);

vF = distanceDamping(dF, strength);

vals = [1 1 vF 1];

end

