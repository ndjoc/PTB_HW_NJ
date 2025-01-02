Screen('Preference', 'SkipSyncTests', 1); % Skip sync tests for testing purposes
[win, rect] = Screen('OpenWindow', 0, 128, [0 0 1280 832]);
[xCenter, yCenter] = RectCenter(rect); % Screen center

% Display Instructions
instructions = [
    'Welcome to our experiment.\n\n', ...
    'You will be presented with pictures of faces.\n\n', ...
    'If the person in the picture is famous, press "F".\n\n', ...
    'If the person in the picture is not famous, press "N".\n\n', ...
    'Press any key to begin.'
];

% Set text size and color
Screen('TextSize', win, 24); % Adjust text size if needed
textColor = [255, 255, 255]; % White text

% Draw the instructions on the screen
DrawFormattedText(win, instructions, 'center', 'center', textColor);
Screen('Flip', win);

% Wait for a key press to proceed  
KbStrokeWait;

% Define keys for responses
KbName('UnifyKeyNames');
famousKey = KbName('F'); % Key for famous faces
nonFamousKey = KbName('N'); % Key for non-famous faces

% Define image directories
famousDir = '/Users/niklasjocher/Library/CloudStorage/OneDrive-Personal/Dokumente/Universität Salzburg/MSc. Psychologie/Semester 1 WS2425/UE Introduction to scientific programming/PTB_HW/famous_faces/';
nonFamousDir = '/Users/niklasjocher/Library/CloudStorage/OneDrive-Personal/Dokumente/Universität Salzburg/MSc. Psychologie/Semester 1 WS2425/UE Introduction to scientific programming/PTB_HW/non_famous_faces/'; 

% Get list of images
famousFiles = dir(fullfile(famousDir, '*.jpg'));
nonFamousFiles = dir(fullfile(nonFamousDir, '*.jpg'));

% Combine famous and non-famous images
allFiles = [famousFiles; nonFamousFiles];
labels = [ones(1, numel(famousFiles)), zeros(1, numel(nonFamousFiles))]; % 1 for famous, 0 for non-famous

% Shuffle images and labels
rng('shuffle');
shuffledIdx = randperm(length(allFiles));
allFiles = allFiles(shuffledIdx);
labels = labels(shuffledIdx);

% Loop through trials
nTrials = length(allFiles);
responses = nan(1, nTrials); % Preallocate for responses
reactionTimes = nan(1, nTrials); % Preallocate for reaction times

for trial = 1:nTrials
    % Draw a cross
    DrawFormattedText(win, '+', 'center', 'center', 255);
    Screen('Flip', win);
    WaitSecs(2)

    % Mask
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
    
    % Load image
    imgPath = fullfile(allFiles(trial).folder, allFiles(trial).name);
    img = imread(imgPath);
    texture = Screen('MakeTexture', win, img);
    
    % Display image
    Screen('DrawTexture', win, texture, [], [], 0);
    Screen('Flip', win);
    
    % Record response
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
    
    % Clear the screen
    Screen('Flip', win);
    WaitSecs(0.5); % Short break between trials
end

% Save results
results.responses = responses;
results.reactionTimes = reactionTimes;
results.correct = responses == labels; % Correct responses
results.accuracy = mean(results.correct) * 100; % Accuracy percentage
save('results.mat', 'results');

% Display results
disp(['Accuracy: ', num2str(results.accuracy), '%']);

% Close the screen
Screen('CloseAll');
