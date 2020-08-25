function amp = db2Amp(db)
%DB2AMP Simple decibel to amplitude conversion.
%   Does the same thing as db2mag, I didn't check for a built-in function
%   before I made this one. :headdesk:

amp = 10^(db/20);

end

