% This function calculates the Mean Square Displacement from the initial 
% position and plots the MSD vs time.

% data_all=uipickfiles;
% data_set = {[1:3];[4:6]}; %From the example files
% data_set = {[1:5];[6:9];[10:14];[15:19];[20:24];[25:29];[30:34];[35:39];[40:50]};
no_lag_points = 50;
for kkk=1:length(data_set)
%     CT=cbrewer('qual', 'Accent',length(data_set));
%  data_file = cell2mat(data_set(kkk));   
 data = data_all(cell2mat(data_set(kkk)));
 All_MSD={};
 for iii=1:length(data)
pool_output=cell2mat(data(iii));
cd((strcat(pool_output,'\','TrackingPackage','\','tracks')));
filename=(strcat(pool_output,'\','TrackingPackage','\','tracks','\','Channel_1_tracking_result.mat'));
% r=load('Channel_1_tracking_result.mat');
r=load(filename);
v=r.tracksFinal;
v1=struct2cell(v);
C1=v1(2,:);
% C2=v1(3,:);
pixel_size=0.16; %%% INPUT  Unit in micrometer
frame_rate=0.025;  %%% INPUT  Unit in sec
% num_of_frames=500;
% MSD=zeros(4000,size(C1,2));
% q1=[];

for p=1:no_lag_points % INPUT change for the number of lag times 
    MSD=zeros(4000,size(C1,2));
    for j=1:size(C1,2)
    D1=C1(:,j);
%     D2=C2(:,j);
    E1=cell2mat(D1);
%     E2=cell2mat(D2);
        x=(E1(1:8:size(E1,2)))*pixel_size;
        y=(E1(2:8:size(E1,2)))*pixel_size;
        if length(x)>50
              if length(x)>(p+1)
                  for ii=1:(size(x,2)-p)
                       MSD(ii,j) = ((x(ii) - x(ii+p)).^2+(y(ii)-y(ii+p)).^2)./(4*p*0.025);
%                        MSD(ii,j) = ((x(ii) - x(ii+p)).^2+(y(ii)-y(ii+p)).^2);
                  end
              end
        end
    end
% figure
MSD1 =MSD(MSD>0);
% MSD = MSD/(max(MSD));
All_MSD{iii,p} =MSD1;
end

 end
 % Filtering out 
 
 tMSD1=[];DATA_MSD=[];
for kk=1:size(All_MSD,2)
%      tMSD1=[];
     
    for jj =1:iii
        tMSD=(All_MSD(:,kk));
        tMSD1=cellfun(@mean,tMSD);
        mean_MSD(kk) = mean(tMSD1);
        sd_MSD(kk)  = std(tMSD1)./sqrt(iii);
%         tMSD1=[tMSD1;tMSD];
%         clear tMSD
%         scatter(jj*ones(1,length(tMSD1)),tMSD1,20,'ob','filled', 'MarkerFaceAlpha',0.4 );hold on

    end
%         DATA_MSD(1,kk) = mean(tMSD1);
%         DATA_MSD(2,kk) = std(tMSD1)./length(tMSD1);
%         DATA_MSD(2,kk) = std(tMSD1)./sqrt(length(tMSD1));

%         DATA_MSD(3,kk) = length(tMSD1);
end
% DATA_MSD(1,:) = DATA_MSD(1,:)/DATA_MSD(1,1);
% DATA_MSD(1,kk) = DATA_MSD(1,kk)./max(DATA_MSD(1,1));
% figure;
time=frame_rate*(1:100);
% [l,p]=boundedline(time,mean_MSD,sd_MSD,'transparency', 1,'cmap',CT(kkk,:));hold on


%     tMSD=tMSD(tMSD>0);
%     c=rand(1,3);
%     time=(1:length(tMSD)).*0.025;
%     plot(time,tMSD,'o-','color',c,'MarkerFaceColor',c,'MarkerEdgeColor','none');
    hold on;box on
%     scatter(time,mean_MSD,'o','filled');
%     errorbar(time,mean_MSD,sd_MSD)
% clearvars -except data
All_total_MSD{kkk}=All_MSD;

end
%% Plostting MSDs
tMSD1=[];DATA_MSD=[];
CT=cbrewer('qual', 'Set1',21);
CT(1,:)=[0,0,0]./255;
CT(2,:)=[33,102,172]./255;
CT(3,:)=[244,165,130]./255;
CT(4,:)=[178,24,43]./255;
for j=1:length(All_total_MSD)
    All_MSD1 = All_total_MSD(j);All_MSD=All_MSD1{1,1};
       tMSD1=[];
     mean_MSD=[];
     sd_MSD=[];
for kk=1:no_lag_points %size(All_MSD,2)
  
    for jj =1:size(All_MSD,1)
        tMSD=(All_MSD(:,kk));tMSD = tMSD(~cellfun('isempty',tMSD));
        tMSD1=cellfun(@mean,tMSD);
        mean_MSD(kk) = mean(tMSD1);
        sd_MSD(kk)  = std(tMSD1)./sqrt(length(tMSD));
%         tMSD1=[tMSD1;tMSD];
%         clear tMSD
%         scatter(jj*ones(1,length(tMSD1)),tMSD1,20,'ob','filled', 'MarkerFaceAlpha',0.4 );hold on

    end
%         DATA_MSD(1,kk) = mean(tMSD1);
%         DATA_MSD(2,kk) = std(tMSD1)./length(tMSD1);
%         DATA_MSD(2,kk) = std(tMSD1)./sqrt(length(tMSD1));

%         DATA_MSD(3,kk) = length(tMSD1);
end
% DATA_MSD(1,:) = DATA_MSD(1,:)/DATA_MSD(1,1);
% DATA_MSD(1,kk) = DATA_MSD(1,kk)./max(DATA_MSD(1,1));
% figure;
time=0.025*(1:no_lag_points);
[l,p]=boundedline(time(1:no_lag_points),mean_MSD,sd_MSD,'transparency', 0.3,'cmap',CT(j,:));hold on
p.FaceAlpha=0.5;l.Marker='o';l.MarkerSize=4;l.LineWidth=2;

end

set(gca, 'LineWidth', 2);
set(gca,'FontSize',20);box on;
set(gca,'YScale','log');set(gca,'XScale','log');
ylabel('MSD <\Deltar^2>, (\mum^2)');xlabel('Lag time, (s)');xlim([0.01,10]);ylim([0.01,10]);
plot(logspace(-8,1,100),logspace(-8,1,100),'--')
plot(logspace(-8,1,100),logspace(-8,1,100),'--')
h=get(gca,'Children');
legend(h([end-1:-2:2]));

