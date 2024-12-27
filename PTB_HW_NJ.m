%% Get images 
% Define directories
famousDir = '/Users/niklasjocher/Library/CloudStorage/OneDrive-Personal/Dokumente/Universität Salzburg/MSc. Psychologie/Semester 1 WS2425/UE Introduction to scientific programming/PTB_HW/famous_faces/';
nonFamousDir = '/Users/niklasjocher/Library/CloudStorage/OneDrive-Personal/Dokumente/Universität Salzburg/MSc. Psychologie/Semester 1 WS2425/UE Introduction to scientific programming/PTB_HW/non_famous_faces/'; 

% Get list of PNG files in each folder
famousFiles = dir(fullfile(famousDir, '*.png'));
nonFamousFiles = dir(fullfile(nonFamousDir, '*.png'));

% Preallocate cell arrays to store images
numFamous = numel(famousFiles);
numNonFamous = numel(nonFamousFiles);

famousImages = cell(1, numFamous);
nonFamousImages = cell(1, numNonFamous);

% Load famous faces
for i = 1:numFamous
    imgPath = fullfile(famousDir, famousFiles(i).name);
    famousImages{i} = imread(imgPath);
end

% Load non-famous faces
for i = 1:numNonFamous
    imgPath = fullfile(nonFamousDir, nonFamousFiles(i).name);
    nonFamousImages{i} = imread(imgPath);
end
%% fixation cross & mask with time jitter 
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
    squareSize = 350; % Size of the square
    [xCenter, yCenter] = RectCenter(rect); % Center the square in the window
    
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
    
    % Show picture of famous/non-famous face

    % maybe reaction time
    % Clean up
    Screen('CloseAll');
end
