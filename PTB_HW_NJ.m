%% Fixation Cross
% Set up screen 
Screen('Preference', 'SkipSyncTests', 1);
[win, rect] = Screen('OpenWindow', 0, 128, [0 0 640 416]);
Screen('TextSize', win, 50);
xCenter = rect(3) / 2; yCenter = rect(4) / 2;

% Draw a cross
DrawFormattedText(win, '+', 'center', 'center', 255);
Screen('Flip', win);
KbStrokeWait