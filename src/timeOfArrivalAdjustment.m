function adjTimeArray = timeOfArrivalAdjustment(timeArray)
%TIMEOFARRIVALADJUSTMENT Removes the time of arrival by subtracing the
%smallest element in the array from all elements.
%   If time-distance compensation is NOT desired, then it needs to be
%   adjusted for. This function find the smallest element in the time
%   array and subtracts that amount from all the other elements in the
%   array. This removes the delay between the sound source and the closest
%   microphone while keeping the time differences between the microphones.

    adj = min(timeArray);
    adjTimeArray = timeArray - adj;

end

