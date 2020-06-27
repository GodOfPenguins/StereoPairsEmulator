function vMic = virtualMicrophone(p, theta)
    vMic = omniMic(p) + biMic(p, theta);
end

function o = omniMic(p)
    o = (1 - p) * 1.41421356237; % (1-p) * sqrt(2)
end

function b = biMic(p, theta)
    b = p * cos(theta);
end