% Psychtoolbox basic Latin Square Task (LST) by Luke Hearne (QBI), early 2014.

% This script presents a LST, followed by a motor response period and a
% confidence rating. Accuracy is reported after each block.
% This script depends upon PsycToolBox V3 (tested on 3.0.12 and MATLAB
% (tested in 2014b,2013b,2017b)
  
clearvars
clc

% Setup inputs
sub.Number = input('Subject Number? ');
sub.DateTime = fix(clock);
respOrder = input('Response Order? ');
fileName = ['Sub_',num2str(sub.Number),'_LST_results'];
if exist([fileName,'.mat'], 'file')==2 && sub.Number ~= 999
    disp('File name already exists');
end

% Setup/Restrict keys
RestrictKeysForKbCheck(KbName(cellstr(['1!   '; '2@   '; '9(   '; '0)   '; 'space'])));

% Setup screen
PsychDefaultSetup(2); %Call default settings for PTB
Screen('Preference','DefaultFontName','Helvetica');
screenNumber = max(Screen('Screens')); % Draw to the external screen if avaliable
[window, rect] = Screen('OpenWindow', screenNumber, [0 0 0]);
param.grey = [150 150 150];

% Experiment Parameters
param.trialNum = 144;
param.trialInBlock = 8;
blockNum = (param.trialNum/param.trialInBlock);
trialCount = 1;

% Trial order --- this could be improved but requires some thought.
load('Seq.mat');
Seq = reshape(reshape(Seq.',1,[]),[36,4]);
Order.Bin = Shuffle(1:36);Order.Ter = Shuffle(37:72);
Order.Qua = Shuffle(73:108);Order.Nul = Shuffle(109:144);

for i=1:param.trialNum
    switch Seq(i)
        case 1
            param.trialOrder(i)=Order.Bin(1);Order.Bin(1)=[];
        case 2
            param.trialOrder(i)=Order.Ter(1);Order.Ter(1)=[];
        case 3
            param.trialOrder(i)=Order.Qua(1);Order.Qua(1)=[];
        case 4
            param.trialOrder(i)=Order.Nul(1); Order.Nul(1)=[];
    end
end


param.time.LST = 3;
param.time.limit = 2;
param.time.jitterOne = ones(1,param.trialNum)+1;%(This is for fMRI design)
param.time.jitterTwo = ones(1,param.trialNum);
save(fileName, 'sub','respOrder');% Results file

% setup LST grid
param.linewidth = 4;
drawData = setup_LST_stimuli(rect,param.linewidth);
%LST Task Data
load('taskData.mat');
% 'Rotate' the correct answer depending on the response order
switch respOrder
    case 1
        corAns = taskData(:,17);
    case 2
        corAns = (taskData(:,17))-1;
    case 3
        corAns  = (taskData(:,17))-2;
    case 4
        corAns  = (taskData(:,17))-3;
end
corAns(corAns == 0)=4;  %byproduct of previous code
corAns(corAns == -1)=3; %corrects shapes
corAns(corAns == -2)=2;

% Calculate the correct shapes to present on the motor response screen
switch respOrder  % 1 = SQUARE 2 = CIRCLE 3 = TRIANGLE 4 = CROSS
    case 1
        motorOrder = [1 2 3 4];
    case 2
        motorOrder = [2 3 4 1];
    case 3
        motorOrder = [3 4 1 2];
    case 4
        motorOrder = [4 1 2 3]; %i.e. cross, square, circle, tri
end

clear('OrderC1','OrderC2','OrderC3','OrderNull')
%% Start experiment

% Main experiment instructions
Screen('TextSize', window, 18);
Screen('TextFont', window, 'Microsoft Sans Serif');
Screen('TextColor', window, param.grey);
DrawFormattedText(window, ['This is the main experiment.','\n','\n',...
    'Try to be as accurate as possible throughout the experiment.','\n','\n',...
    'If you have any questions, or are unclear about what to do','\n','\n',...
    'now would be a good time to ask the experimenter.','\n','\n',...
    'The response keys are 1, 2, 9 & 0.','\n','\n',...
    'Press a key to begin.']...
    , 'center', 'center');
Screen('Flip', window);
HideCursor();
KbPressWait();

for j = 1:blockNum% Start block loop
    
    Screen('TextSize', window, 24);% Block will begin shortly...
    Screen('TextColor', window, param.grey);
    DrawFormattedText(window, ['Block ' num2str(j),' out of ' num2str(blockNum), ' will begin shortly...'], 'center', 'center');
    Screen('Flip', window);
    WaitSecs(1.0);
    
    % Start trial loop 
    for i = trialCount:(trialCount+(param.trialInBlock-1))
        trialCount = trialCount+1;
        present_jitter(param.time.jitterOne(i),window,param.grey);
        
        % Present LST for 5 seconds
        Screen('FrameRect', window, param.grey, drawData.Rects, param.linewidth);
        for k=1:16
            switch taskData(param.trialOrder(i),k)
                case 0
                    %Do nothing
                case 9
                    Screen('DrawText', window, '?', (drawData.stimPos(1,k)-(0.4*drawData.sLength)),...
                        (drawData.stimPos(2,k)-(0.8*drawData.sLength)), [255 0 0]);
                case 11
                    Screen('DrawText', window, '*', (drawData.stimPos(1,k)-(0.4*drawData.sLength)),...
                        (drawData.stimPos(2,k)-(0.5*drawData.sLength)), [255 0 0]);
                case 1
                    Screen('FillRect', window, param.grey, drawData.shapeRect((1:4),k));
                case 2
                    Screen('FillOval', window, param.grey, drawData.shapeRect((1:4),k));
                case 3
                    Screen('FillPoly', window, param.grey, drawData.shapeTri(1:3,k*2-1:k*2)); 
                case 4
                    Screen('FillRect', window, param.grey, drawData.shapeCrossA((1:4),k)); 
                    Screen('FillRect', window, param.grey, drawData.shapeCrossB((1:4),k));
            end
        end
        
        Screen('Flip', window);
        WaitSecs(param.time.LST);
        present_jitter(param.time.jitterTwo(i),window,param.grey);
        
        % Present  and record motor response
        Screen('TextColor', window, param.grey);
        DrawFormattedText(window, '?', 'center', 'center');
        k = 1:4;
        if param.trialOrder(i) > 108 %if trial = null, draw an asterix
            Screen('DrawText', window, '*', ...
                (drawData.stimPos(1,(corAns(param.trialOrder(i))+12))-20),...
                (drawData.stimPos(2,(corAns(param.trialOrder(i))+12))-20), [255 0 0]);
            k(corAns(param.trialOrder(i)))= [];
        end
        
        for l=k 
            switch motorOrder(l)
                case 1
                    Screen('FillRect', window, param.grey, drawData.shapeRect((1:4),(l+12)));
                case 2
                    Screen('FillOval', window, param.grey, drawData.shapeRect((1:4),(l+12)));
                case 3
                    Screen('FillPoly', window, param.grey, drawData.shapeTri(1:3,l*2-1+24:l*2+24));
                case 4
                    Screen('FillRect', window, param.grey, drawData.shapeCrossA((1:4),(l+12)));
                    Screen('FillRect', window, param.grey, drawData.shapeCrossB((1:4),(l+12)));
            end
        end
        
        onsetTime = Screen('Flip', window);
        [respTime, respKey] = KbPressWait([],(onsetTime+2));
        rec.RT(i) = respTime - onsetTime;
        if rec.RT(i) <=param.time.limit 
            respKey = KbName(respKey);
            rec.Key(i) = str2double(respKey(1));
            if rec.Key(i) == 9
                rec.Key(i) = 3;
            end
            if rec.Key(i) == 0
                rec.Key(i) = 4;
            end
        else
            rec.Key(i) = 999;
        end
        rec.Acc(i)=rec.Key(i)==corAns(param.trialOrder(i));
        WaitSecs(param.time.limit-rec.RT(i));
        
        % Present and record confidence interval
        Screen('TextColor', window, param.grey);
        Screen('TextSize', window, 24);
        DrawFormattedText(window,'Confidence Rating', 'center', (rect(4) / 2)-(.25*(rect(4) / 2)));
        Screen('TextSize', window, 36);
        DrawFormattedText(window,'1          2          9', 'center', (rect(4) / 2));
        Screen('TextSize', window, 18);
        DrawFormattedText(window,'100% Guess          -       100% Confident', 'center', (rect(4) / 2)+(.25*(rect(4) / 2)));
        onsetTime = Screen('Flip', window);
        [respTime, respKey] = KbPressWait([],(onsetTime+2)); %Time limit is set to 1
        
        rec.confRT(i) = respTime - onsetTime; 
        if rec.confRT(i) <=2
            respKey = KbName(respKey);
            rec.confKey(i) = str2double(respKey(1));
            if rec.confKey(i) == 9
                rec.confKey(i) = 3;
            end
        else
            rec.confKey(i) = 999;
        end
        WaitSecs(2-rec.confRT(i));
        save(fileName, 'sub','respOrder', 'param', 'rec', '-append');
    end
    
    % Block feedback
    avgAcc = (sum(rec.Acc(((trialCount)-param.trialInBlock):(trialCount-1)))/(param.trialInBlock))*100;
    Screen('TextSize', window, 18);
    DrawFormattedText(window, ...
        ['Across the last block', '\n'...
        'you scored correctly ',num2str(avgAcc),'% of the time!','\n','\n',...
        'Press spacebar to continue'],...
        'center', 'center');
    Screen('Flip', window);
    KbPressWait();
end

% Finishing screen
DrawFormattedText(window, 'Well done! You are finished.', 'center', 'center');
Screen('Flip', window);
KbPressWait()
ShowCursor();
Screen('CloseAll');