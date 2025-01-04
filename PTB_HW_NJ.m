% This is the code for the PTB homework 
% Initial set up: Open a grey window and calculate center of the screen 
Screen('Preference', 'SkipSyncTests', 1); 
[win, rect] = Screen('OpenWindow', 0, 128, [0 0 1280 832]);
[xCenter, yCenter] = RectCenter(rect);

% Display Instructions 
% Specify instructions 
instructions = [
    'Welcome to our experiment.\n\n', ...
    'You will be presented with pictures of faces.\n\n', ...
    'If the person in the picture is famous, press "F".\n\n', ...
    'If the person in the picture is not famous, press "N".\n\n', ...
    'Press any key to begin.'
];

% Text size and color: make color white 
Screen('TextSize', win, 24); 
textColor = [255, 255, 255];

% Show instructions on the screen 
DrawFormattedText(win, instructions, 'center', 'center', textColor);
Screen('Flip', win);

% participant can press a key to continue when done with reading the 
% instructions 
KbStrokeWait;

% Participants are supposed to press a key depending on if its a famous
% face or a non famous face. 'F' is for famous and 'N' is for non famous
KbName('UnifyKeyNames');
famousKey = KbName('F'); % Key for famous faces
nonFamousKey = KbName('N'); % Key for non-famous faces

% Tell matlab where it can find the images 
famousDir = '/Users/niklasjocher/Library/CloudStorage/OneDrive-Personal/Dokumente/Universität Salzburg/MSc. Psychologie/Semester 1 WS2425/UE Introduction to scientific programming/PTB_HW/famous_faces/';
nonFamousDir = '/Users/niklasjocher/Library/CloudStorage/OneDrive-Personal/Dokumente/Universität Salzburg/MSc. Psychologie/Semester 1 WS2425/UE Introduction to scientific programming/PTB_HW/non_famous_faces/'; 

% Make a list of the famous faces and non famous faces
famousFiles = dir(fullfile(famousDir, '*.jpg'));
nonFamousFiles = dir(fullfile(nonFamousDir, '*.jpg'));

% Combine famous and non-famous images (1 is for famous faces and 0 for non
% famous faces) 
allFiles = [famousFiles; nonFamousFiles];
labels = [ones(1, numel(famousFiles)), zeros(1, numel(nonFamousFiles))]; 

% Shuffle the order of the images so its random
rng('shuffle');
shuffledIdx = randperm(length(allFiles));
allFiles = allFiles(shuffledIdx);
labels = labels(shuffledIdx);

% Make a loop for all trials
nTrials = length(allFiles);

% We want to record reaction times so we'll prepare an array to store them
% in 
reactionTimes = nan(1, nTrials); 


for trial = 1:nTrials
    % Draw a fixation cross (big plus) that is diplayed for 2 seconds 
    DrawFormattedText(win, '+', 'center', 'center', 300);
    Screen('Flip', win);
    WaitSecs(2)

    % Mask
    % Define square size and position (center of the screen)
    squareSize = 350; 
    [xCenter, yCenter] = RectCenter(rect); 
    
    % Generate random noise and jitter
    noiseMatrix = rand(squareSize, squareSize) * 300; 
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
    
    % Load image
    imgPath = fullfile(allFiles(trial).folder, allFiles(trial).name);
    img = imread(imgPath);
    texture = Screen('MakeTexture', win, img);
    
    % Display image
    Screen('DrawTexture', win, texture, [], [], 0);
    Screen('Flip', win);
    
    % Record response for key presses 
    startTime = GetSecs;
    responded = false;
    while ~responded
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(famousKey)
               responses(trial) = 1; % Famous
               responded = true;
            elseif keyCode(nonFamousKey)
                responses(trial) = 0; % Non-famous
                responded = true;
            end
        end
    end
    reactionTimes(trial) = GetSecs - startTime;
    
    % Clear the screen and wait 0.5 seconds before the next trial starts
    Screen('Flip', win);
    WaitSecs(0.5);
end

% Save results
results.reactionTimes = reactionTimes;
save('results.mat', 'results');

% Close the screen
Screen('CloseAll');
