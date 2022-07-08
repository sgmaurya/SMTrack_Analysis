all_data=uipickfiles('Type',{'*.mat',   'MAT-files'} );
% movieInfo={};
stepcount=[];
for j=1:length(all_data)
    load(cell2mat(all_data(j)));
    [f1 f2 f3]=fileparts(cell2mat(all_data(j)));

for i=1:size(traces,1)
I1 = traces(i,:);
    a=stepDetection(I1,10,2 ,20,5);
    stepcount(j,i)=(table2array(a(1,1)));
end
end
%% 
for k=1:size(stepcount,1)
    daa=stepcount(k,:);figure
    h=histogram(daa(daa>0),[0.5:1:12.5],'Normalization','probability');
    valueS(:,k) = h.Values;close
end
figure
for j=1:12
    plot(time1,valueS(j,:));hold on
end

%% 
Prob_calc
%
for k=1:length(time)
    data_set{k}=k;
end
%
% data_set = {[1:5];[6:10];[11:15];[16:21];[22:27];[28:32];[33:39];[40:45];[46:51];[55:60];[61:64];[65:67];[72:74];[75:77]};
% data_set = {[1:4];[5:8];[9:13];[14:19];[20:23];[24:28];[29:34];[35:38];[39:44];[45:47];[48:52];[53:58];[59:62];[63:67];[68:72]};

All_pred={};All_obs={};
for j=1:length(time)
    pool_output=cell2mat(data_set(j));
    data1=stepcount(pool_output,:);
    mean_n_obs=[];mean_s=[];stdERROR_obs=[];stdERROR_s=[];s=[];n_obs=[];
for i=1:size(data1,1)
    temp_data=data1(i,:);
    figure;
    h=histogram(temp_data(temp_data>0 & temp_data<13),12,...
    'BinEdges',(0.5:1:12.5),'Normalization',...
    'probability','DisplayStyle','stairs','Linewidth',3);
    n=h.Values;close;
    n_obs(:,i)=n;
    s(:,i)=inv(transpose(Prob_Coeff1))*n';
end
s(s<0)=0;
for kk=1:size(s,2)
    s(:,kk)=s(:,kk)./sum(s(:,kk));
end
All_obs{j} = n_obs;
All_pred{j} = s;
end

%% 
CT=cbrewer('qual', 'Dark2',20);
mass_fraction =  [1:12];
All_mass_data=[];

% mass_fraction =  ones(1,12);
for p=1:length(All_pred)
    temp_data = cell2mat(All_obs(p));
    mass_data=[];
    for q=1:size(temp_data,2)
        mass_data(:,q) =  temp_data(:,q).*mass_fraction';
        mass_data(:,q) = mass_data(:,q)./sum(mass_data(:,q));
    end
    All_mass_data(:,p) = mass_data;
end
figure
for j=1:12
    plot(time,All_mass_data(j,:));hold on
end
%%
All_mass_data=[];
for p=1:length(All_pred)
    temp_data = cell2mat(All_pred(p));
    mass_data=[];
    for q=1:size(temp_data,2)
        mass_data(:,q) =  temp_data(:,q).*mass_fraction';
        mass_data(:,q) = mass_data(:,q)./sum(mass_data(:,q));
    end
    All_mass_data(:,p) = mass_data;
end
figure
for j=1:12
    plot(time,All_mass_data(j,:));hold on
end

%%  Averaging 
CT=cbrewer('qual', 'Dark2',9);
for kk=1:12
    d1(1,:)=All_mass_data1(kk,:);
    d1(2,:)=All_mass_data2(kk,:);
    d1(3,:)=All_mass_data3(kk,:);
    meanD=mean(d1,1);stdD=std(d1,[],1)./3;
    meanD_all(kk,:)=meanD;stdD_all(kk,:)=stdD;
end

% for kk=1:12
% [l,p]=boundedline(time1,smooth(meanD(:,kk),'moving'),stdD(:,kk),'transparency', 0.3,'cmap',CT(kk,:));
% p.FaceAlpha=0.5;l.Marker='o';l.MarkerSize=4;l.LineWidth=2;
box on;set(gca,'FontSize',16);set(gca, 'LineWidth', 2);
xlabel('Time, min');ylabel('Oligomers');
% end


