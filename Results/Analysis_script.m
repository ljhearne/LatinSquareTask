% LST and RPM analysis script for thesis stats and figures, Feb 2017

clearvars
clc

%subjects in analysis
subj = [1:33 35:42];
N    = length(subj);
T    = 144; %trials
C    = 8; %conditions
TC   = T/C;
%% Organize data

%--- APM ---%

%APM.S1CorAns = [8 4 5 1 2 5 6 3 7 8 7 6];% Correct answers
APM.S2CorAns    = [5 1 7 4 3 1 6 1 8 4 5 6 2 1 2 4 6 7 3 8 8 7 6 3 7 2 7 5 6 5 4 8 5 1 3 2];
APM.S2data      = zeros(length(subj),36);
APM.S2acc       = zeros(length(subj),36);
path            ='/Users/uqlhear2/ownCloud/2_PhD/1_LST_behav/5_Data/Study1/';

for j = 1:length(subj)
    
    % Load data
    filename        = [path,'Sub_',num2str(subj(j)), '_APM_Set2_results.mat'];
    tData           = load(filename);
    APM.S2data(j,:) = tData.resp; % APM set 2.
    APM.time(j)     = tData.timer.current/60; % the time it took to complete.
    
end

APM.S2acc       = APM.S2data == APM.S2CorAns;% Check accuracy
APM.S2accTotal  = sum(APM.S2acc,2);

%--- LST---%

for j = 1:length(subj)
    
    filename = [path,'Sub_',num2str(subj(j)), '_LST_results.mat'];
    tData = load(filename);
    
    LSTacc.Data(j,tData.param.trialOrder)       = tData.rec.Acc;
    LSTRT.Data(j,tData.param.trialOrder)        = tData.rec.RT;
    LSTMissedResponse(j,tData.param.trialOrder) = tData.rec.Key;
        
end

% Accuracy
LSTacc.Total = sum(LSTacc.Data(:,1:108),2);
LSTacc.Cond  = squeeze(sum(reshape(LSTacc.Data,[N,TC,C]),2));
LSTacc.CondNoSteps  = squeeze(sum(reshape(LSTacc.Data,[N,TC*2,C/2]),2));

% Reaction Time
LSTRT.Data(LSTMissedResponse == 999) = NaN;
LSTRT.Total = nanmean(LSTRT.Data(:,1:108),2);
LSTRT.Cond  = squeeze(nanmean(reshape(LSTRT.Data,[N,TC,C]),2));
LSTRT.CondNoSteps  = squeeze(nanmean(reshape(LSTRT.Data,[N,TC*2,C/2]),2));

%--- Test-retest data ---%

subj2 = [1,2,7,9,16,17,18,21,24,25,28,30,31,32,33,35,36,41,42];
N2    = length(subj2);
path2='/Users/uqlhear2/ownCloud/2_PhD/1_LST_behav/5_Data/Study2 - retest/';

for j = 1:length(subj2)
    
    filename = [path,'Sub_',num2str(subj2(j)),'_LST_results.mat'];
    tData    = load(filename);
    LSTaccRetest.S1.Data(j,tData.param.trialOrder) = tData.rec.Acc; % accuracy data
    LSTaccRetest.S1.Date(j,:)=tData.sub.DateTime;
    
    filename = [path2,'Sub_',num2str(subj2(j)),'_LST_RETEST_results.mat'];
    tData    = load(filename);
    LSTaccRetest.S2.Data(j,tData.param.trialOrder) = tData.rec.Acc; % accuracy data
    LSTaccRetest.S2.Date(j,:)=tData.sub.DateTime;
end

% Session 1 accuracy
LSTaccRetest.S1.Total = sum(LSTaccRetest.S1.Data(:,1:108),2);
LSTaccRetest.S1.Cond  = squeeze(sum(reshape(LSTaccRetest.S1.Data,[N2,18,8]),2));

% Session 2 accuracy
LSTaccRetest.S2.Total = sum(LSTaccRetest.S2.Data(:,1:108),2);
LSTaccRetest.S2.Cond  = squeeze(sum(reshape(LSTaccRetest.S2.Data,[N2,18,8]),2));

%% STATS
%lose_nan(1)

% Note: ANOVA's, t-tests, etc., were done in JASP.

% means and standard deviation
desTable.means = mean((LSTacc.Cond/TC*100));
desTable.stdevs = std((LSTacc.Cond/TC*100));
desTable.meansNoSteps = mean((LSTacc.CondNoSteps/36*100));
desTable.stdevsNoSteps = std((LSTacc.CondNoSteps/36*100));
desTable.meansTot = mean(LSTacc.Total/108*100);
desTable.stdevsTot = std(LSTacc.Total/108*100);

desTableRT.means = mean(LSTRT.Cond);
desTableRT.stdevs = std(LSTRT.Cond);
desTableRT.meansNoSteps = mean(LSTRT.CondNoSteps);
desTableRT.stdevsNoSteps = std(LSTRT.CondNoSteps);
desTableRT.meansTot = mean(LSTRT.Total);
desTableRT.stdevsTot = std(LSTRT.Total);

% correlation between LST and ACC
[r_tot,p_tot]=corr(LSTRT.Total,APM.S2accTotal);
disp(['Correlation between overall LST RT and APMS2, r = ',num2str(r_tot),' p = ',num2str(p_tot)]);
[r_tot,p_tot]=corr(LSTacc.Total,APM.S2accTotal);
disp(['Correlation between overall LST and APMS2, r = ',num2str(r_tot),' p = ',num2str(p_tot)]);

% internal reliability
cronbachA(1,1) = cronbachsAlpha(LSTacc.Data(:,1:108));
cronbachA(1,2) = cronbachsAlpha(LSTRT.Data(:,1:108));

idx  = 1:TC:T;
idx2 = 18:TC:T;

for i = 1: C % only interesting conditions
    cronbachA(i+1,1) = cronbachsAlpha(LSTacc.Data(:,idx(i):idx2(i)));
    cronbachA(i+1,2) = cronbachsAlpha(LSTRT.Data(:,idx(i):idx2(i)));
end

% test-retest reliability
corr_type = 'Spearman';
[rRetest,pRetest]=corr(LSTaccRetest.S1.Total,LSTaccRetest.S2.Total,'type',corr_type);

for i = 1: C % only interesting conditions
    
    [rRetest(i+1),pRetest(i+1)]=corr(LSTaccRetest.S1.Cond(:,i),...
        LSTaccRetest.S2.Cond(:,i),'type',corr_type);

end

%date time
LSTaccRetest.Date=(datenum(LSTaccRetest.S2.Date)-datenum(LSTaccRetest.S1.Date))/30;

%null data comparison for review (Null is col 4).
mean(LSTRT.CondNoSteps);

%% PLOTS
close all

figure('Color',[1 1 1], 'units','pixels','outerposition',[300 300 500 200]);
hold on;
set(gcf,'color','w');

col1 = [0.7 0.7 0.7];
col2 = [0.4 0.4 0.4];
msize = 10;
subplot(1,3,1) %APM/LST correlation

scatter(LSTacc.Total/108*100,APM.S2accTotal/36*100,10,'MarkerEdgeColor',...
    [.5 .5 .5],'MarkerFaceColor', [.5 .5 .5] ,'LineWidth',0.5','SizeData',msize)
h = lsline;
set(h,'LineWidth',2,'Color','k');
set(gca,'FontName', 'Helvectica','FontSize', 10,'Box','off','TickDir','out','ygrid','off','XLim',[35 100],'YLim',[35 100]);
xlabel('LST (%)');
ylabel('APM (%)');
set(gca,'YTick',40:20:100, 'FontSize', 10);
set(gca,'XTick',40:20:100);

%-------------------
% Accuracy
subplot(1,3,2)

data=LSTacc.Cond(:,[1,3,5])/18*100;
for i=1:3
    idx = [1 4 7];
    scatter(repmat(idx(i),[N,1]),data(:,i),'MarkerEdgeColor',col1,'MarkerFaceColor',col1,'SizeData',msize)
    median_box(data(:,i),idx(i),.25,col1-.3,1)
    hold on
end

data=LSTacc.Cond(:,[2,4,6])/18*100;
for i=1:3
    idx = [2 5 8];
    scatter(repmat(idx(i),[N,1]),data(:,i),'MarkerEdgeColor',col2,'MarkerFaceColor',col2,'SizeData',msize)

    median_box(data(:,i),idx(i),.25,col2-.3,1)
    hold on
end

set(gca,'FontName', 'Helvectica','FontSize', 10,'Box','off','TickDir','out','ygrid','off','XLim',[.5 8.5],'YLim',[0 100]);
xlabel('Reasoning complexity');
ylabel('Accuracy');
set(gca,'YTick',0:20:100, 'FontSize', 10);
set(gca,'XTick',[1 2 4 5 7 8]);

%-------------------
subplot(1,3,3) % RT

data=LSTRT.Cond(:,[1,3,5]);
for i=1:3
    idx = [1 4 7];
    scatter(repmat(idx(i),[N,1]),data(:,i),'MarkerEdgeColor',col1,'MarkerFaceColor',col1,'SizeData',msize)
    median_box(data(:,i),idx(i),.25,col1-.3,1)
    hold on
end

data=LSTRT.Cond(:,[2,4,6]);
for i=1:3
    idx = [2 5 8];
    scatter(repmat(idx(i),[N,1]),data(:,i),'MarkerEdgeColor',col2,'MarkerFaceColor',col2,'SizeData',msize)

    median_box(data(:,i),idx(i),.25,col2-.3,1)
    hold on
end

set(gca,'FontName', 'Helvectica','FontSize', 10,'Box','off','TickDir','out','ygrid','off','XLim',[.5 8.5],'YLim',[0.4 1.5]);
xlabel('Reasoning complexity');
ylabel('Reaction time (s)');
set(gca,'YTick',.5:.25:2, 'FontSize', 10);
set(gca,'XTick',[1 2 4 5 7 8]);


%-------------------
% %Comparison with Birney.
% fig=figure('Color',[1 1 1], 'units','pixels','outerposition',[300 300 (500/3) 200]);
% hold on;
% set(gcf,'color','w');
% 
% data=LSTacc.Cond(:,[1 3 5]);data=data/18*100;
% plot(mean(data),'Color','k','LineWidth',1,'MarkerSize',5,'Marker','o','MarkerFaceColor','k')
% hold on
% 
% CI(1,:)=mean(data)+(1.96*std(data)/(sqrt(length(data))));
% CI(2,:)=mean(data)-(1.96*std(data)/(sqrt(length(data))));
% 
% for i=1:3
%     h=line([i i],[CI(1,i),CI(2,i)]);
%     set(h,'LineWidth',1,'Color','k');
%     hold on
% end
% 
% data=LSTacc.Cond(:,[2 4 6]);data=data/18*100;
% plot(mean(data),'Color','k','LineWidth',1,'MarkerSize',5,'Marker','^','MarkerFaceColor','k')
% 
% CI(1,:)=mean(data)+(1.96*std(data)/(sqrt(length(data))));
% CI(2,:)=mean(data)-(1.96*std(data)/(sqrt(length(data))));
% 
% data=[96 89 64];
% plot(data,'Color','r','LineWidth',1,'MarkerSize',5,'Marker','^','MarkerFaceColor','k')
% 
% data=[82 77 44];
% plot(data,'Color','r','LineWidth',1,'MarkerSize',5,'Marker','^','MarkerFaceColor','k')
% 
% 
% 
% for i=1:3
%     h=line([i i],[CI(1,i),CI(2,i)]);
%     set(h,'LineWidth',1,'Color','k');
%     hold on
% end
% 
% set(gca,'FontName', 'Arial','FontSize', 12,'Box','off','TickDir','out','ygrid','off','XLim',[.5 3.5],'YLim',[35 100]);
% xlabel('Reasoning complexity');
% ylabel('Accuracy');
% set(gca,'YTick',0:20:100, 'FontSize', 10);
% set(gca,'XTick',0:1:100);
% 
function median_box(data,mid,width,col,lw)

% Draws a box of medians and percentiles at mid.

% Draw horizontal lines
line([mid-width mid+width],[median(data),median(data)],'Color',col,'LineWidth',lw); hold on
line([mid-width mid+width],[prctile(data,25),prctile(data,25)],'Color',col,'LineWidth',lw); hold on
line([mid-width mid+width],[prctile(data,75),prctile(data,75)],'Color',col,'LineWidth',lw); hold on

% Draw vertical lines
line([mid-width mid-width],[prctile(data,25),prctile(data,75)],'Color',col,'LineWidth',lw); hold on
line([mid+width mid+width],[prctile(data,25),prctile(data,75)],'Color',col,'LineWidth',lw); hold on

end

