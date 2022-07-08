% data_all=uipickfiles;
% data_set = {[1:length(data_all)]}; % INPUT: the number of movies in a single type of data
% data_set = {[1:6];[7:12];[13:18];[19:24];[25:30];[31:35]}; % INPUT: the number of movies in a multiple type of data
% data_set = {[1:3];[4:6]}; %From the example files
data_set_ISD={};
for kkk=1:length(data_set)

 data = data_all(cell2mat(data_set(kkk)));
 All_MSD={};
 for iii=1:length(data)
pool_output=cell2mat(data(iii));
cd((strcat(pool_output,'\','TrackingPackage','\','tracks')));
filename=(strcat(pool_output,'\','TrackingPackage','\','tracks','\','Channel_1_tracking_result.mat'));

r=load(filename);
v=r.tracksFinal;
v1=struct2cell(v);
C1=v1(2,:);
% C2=v1(3,:);
pixel_size=0.16; %INPUT: Unit in micrometer
p=1;
    ISD=zeros(4000,size(C1,2));
    
for j=1:size(C1,2)
    D1=C1(:,j);
    E1=cell2mat(D1);
      
        x=(E1(1:8:size(E1,2)))*pixel_size;
        y=(E1(2:8:size(E1,2)))*pixel_size;
        intensity=(E1(4:8:size(E1,2)));
      if length(x)>2 % INPUT: For taking only trajectories greater than 2
        for ii=1:(size(x,2)-2)
            ISD(ii,j) = ((x(ii) - x(ii+2)).^2+(y(ii)-y(ii+2)).^2);
        end
      end
end
ISD1 =ISD(:,:);ISD1=ISD1(ISD1>0);
frame_rate=0.05; % INPUT in seconds
ISD1 = ISD1./(4*frame_rate);
All_ISD{iii,kkk} = ISD1;
% A=randi(length(MSD),1,50);
% All_ISD={}
 end
 % Filtering out 
 data_set_ISD{kkk} =All_ISD;
 All_ISD ={};
 
end

data_all_counts_mean=[];
Da_ta=[]; 
center=logspace(-6,1,100);
center=log10(center);
for j=1:length(data_set_ISD)
    t_ISD = data_set_ISD{j};
    t_ISD(cellfun('isempty',t_ISD)) = [];temp_data=[];
    for t=1:length(t_ISD)
        temp_data = [temp_data;cell2mat(t_ISD(t))];
    end
 
    figure;
    h=histogram(log10(temp_data),center,'Normalization','probability');

        
    data_all_counts_mean(:,j) =  h.Values;
    close
end

%% To plot the ISDs as heat maps. Ideal for multiple set of different data
data_all_centers_mean=center';
imagesc(1:length(data_set),data_all_centers_mean(:,1),data_all_counts_mean)
set(gca,'FontSize',20);
% ylim([-4,1.2]);
xlabel('Sample')   
ylabel('Log(ISD,<\Deltar^2>(4\tau)^-^1)')
% savefig(gcf,'Sauheat_plot_2tau');print('Sauheat_plot_2tau','-djpeg');
%% This section is for plotting as histograms 
% Download cbrewer from MATLAB file exchange website
CT=cbrewer('qual', 'Set1',20);
CT(1,:)=[0,0,0]./255;
CT(2,:)=[33,102,172]./255;
CT(3,:)=[244,165,130]./255;
CT(4,:)=[178,24,43]./255;
data_all_county=[];
Da_ta=[]; 
for j=1:length(data_set)
    t_ISD = data_set_ISD{j};
    t_ISD(cellfun('isempty',t_ISD)) = [];
    data_all_county=[];
    for t=1:length(t_ISD)
        temp_data = cell2mat(t_ISD(t));
 
    figure;
    h=histogram(log10(temp_data),center,'Normalization','probability');

        
    data_all_county(:,t) =  h.Values;
    close
    temp_data=[];
    end
    mEAN1 = mean(data_all_county,2);
    mEAN(:,j) = mean(data_all_county,2);
    sTD1 = std(data_all_county,[],2);
    sTD(:,j) = std(data_all_county,[],2);hold on
%     for k=1:size(data_all_county,2)
%         scatter(data_all_centers_mean(1:199,1),data_all_county(:,k),50,CT(j,:),'MarkerFaceAlpha',0.3);hold on
%     end
%     plot(data_all_centers_mean(1:199,1),smooth(mEAN,'moving'),'Color',CT(j,:),'LineWidth',4)
%     [l,p]=boundedline(data_all_centers_mean(1:199,1),smooth(mEAN1,'sgolay',3),sTD1./size(data_all_county,2),'transparency', 0.3,'cmap',CT(j,:));
        [l,p]=boundedline(data_all_centers_mean(1:99,1),smooth(mEAN1,'moving'),sTD1,'transparency', 0.3,'cmap',CT(j,:));

    p.FaceAlpha=0.8;l.LineWidth=4;
    

end
for k=1:j
    plot(data_all_centers_mean(1:99,1),smooth(mEAN(:,k),'moving'),'Color',CT(k,:),'LineWidth',4)
%     plot(data_all_centers_mean(1:199,1),mEAN(:,k),'Color',CT(k,:),'LineWidth',4)
end
box on;set(gca,'FontSize',20);set(gca, 'LineWidth', 2);
xlabel('Log(ISD, \mum^2s^-^1)')

ylabel('Probability');

%% Violin plot
% download al_goodplot from MATLAB file exchange website
new_violin_data=[];
data_number=[1:1:length(data_set)]; % Put numbers if multiple data sets are there
for k=1:length(data_number)
    data_point=data_number(k);
    data_t= cell2mat(data_set_ISD{1,data_point});
    new_violin_data(:,k)=log10(randsample(data_t,10000));
end
%figure

al_goodplot(new_violin_data,[],0.5,[178 24 43]./255,'left',[],std(new_violin_data(:))/1500);
al_goodplot(new_violin_data,[],0.5,[178 24 43]./255,'right',[],std(new_violin_data(:))/1500);
% figure;
% al_goodplot; title('Example')



