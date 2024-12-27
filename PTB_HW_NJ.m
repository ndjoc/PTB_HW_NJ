%% Fixation Cross
% Set up screen 

for i = 1:2
    Screen('Preference', 'SkipSyncTests', 1);
    [win, rect] = Screen('OpenWindow', 0, 128, [0 0 640 416]);
    Screen('TextSize', win, 50);
    xCenter = rect(3) / 2; yCenter = rect(4) / 2;

    % Draw a cross
    DrawFormattedText(win, '+', 'center', 'center', 255);
    Screen('Flip', win);
    WaitSecs(2)

    % Mask 
    Screen('Preference', 'SkipSyncTests', 1);
    [win, rect] = Screen('OpenWindow', 0, [128, 128, 128], [0 0 640 416]);
    Screen('TextSize', win, 50);
    xCenter = rect(3) / 2; yCenter = rect(4) / 2;
    
    % Define square size and position
    squareSize = 350; % Size of the square in pixels
    [xCenter, yCenter] = RectCenter(rect ); % Get the center of the window
    
    % Generate random noise and jitter
    noiseMatrix = rand(squareSize, squareSize) * 255; % Random values between 0-255
    noiseTexture = Screen('MakeTexture', win, noiseMatrix);
    minTime = 0.1; 
    maxTime = 0.9; 
    jitteredTime = minTime + (maxTime - minTime) * rand;
    
    % Define destination rectangle for the noisy square
    destRect = CenterRectOnPointd([0 0 squareSize squareSize], xCenter, yCenter);
    
    % Draw the texture to the screen
    Screen('DrawTexture', win, noiseTexture, [], destRect);
    Screen('Flip', win)
    
    % Wait for the jittered duration
    WaitSecs(jitteredTime);
    
    % Clean up
    Screen('CloseAll');
end
