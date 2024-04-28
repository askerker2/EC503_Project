%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Before calling this function, an ECG record should be split into R-peak
% segments and stacked into a data matrix. The data matrix should then be
% mean-centered and zero-filled. The start and end index of the signal in
% each row should be kept in refTimes (either 2xn or nx2, where n is the
% number of segments)
% 
% Pass the R-Peak stack and refTimes (segment start/stop)
%
% The function returns the datamatrix (samplesCentered) with each row 
% containing its R-Peak in the middle index and the new start/stop index
% matrix (refTimesShifted)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [samplesCentered, refTimesShifted] = ecgsCentered(matrix, refTimes)
    [m, n] = size(matrix); % Get the size of the input matrix
    [r, c] = size(refTimes); %Get size of refTimes matrix
    if c > r
        refTimes = refTimes';
    end
    refTimesShifted = zeros(size(refTimes));
    samplesCentered = zeros(m, n); % Initialize the shifted matrix
    
    for i = 1:m
        row = matrix(i, :); % Extract the i-th row
        [~, max_index] = max(row); % Find the index of the maximum value
        middle_index = ceil(n/2); % Calculate the middle index
        
        shift_amount = middle_index - max_index; % Calculate the shift amount
        
        % Shift the row to make the max value at the middle index
        shifted_row = circshift(row, [0, shift_amount]);
        
        % Update the shifted matrix
        samplesCentered(i, :) = shifted_row;
        
        % Update the refTimes
        refTimesShifted(i,:) = refTimes(i,:) + shift_amount;
    end
end