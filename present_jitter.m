function present_jitter(J,window,col)
% Present fixation with jitter
Screen('TextSize', window, 60);
Screen('TextColor', window, col);
DrawFormattedText(window, '+', 'center', 'center');
Screen('Flip', window);
WaitSecs(J);
end

