%% MATLAB 2017b 
 % Additional files needed 'cbrewer' and data from step detection code
 % 'Stepcount_immobile'
 p=0.9; % Labelling efficiency 

ProbCoeff=zeros(12,12);
for k = 1:12
    for ll=0:k
    ProbCoeff(k,(ll+1)) = p^(ll)*((1-p)^(k-ll))*nchoosek(k,ll);
    ProbCoeff1(k,(ll+1)) = p^(ll)*((1-p)^(k-ll));
    end
    ll=[];
end
Prob_Coeff = ProbCoeff(:,2:end);
Prob_Coeff1 = ProbCoeff1(:,2:end);

%%
for k=1:35
    data_set{k}=k;
end
%%
% data_set = {[56:58];[52:55]};
% data_set = {[1:4];[5:8];[9:13];[14:19];[20:23];[24:28];[29:34];[35:38];[39:44];[45:47];[48:52];[53:58];[59:62];[63:67];[68:72]};

All_pred={};All_obs={};
for j=1:5
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
All_mass_data={};

% mass_fraction =  ones(1,12);
for p=1:length(All_pred)
    temp_data = cell2mat(All_pred(p));
    mass_data=[];
    for q=1:size(temp_data,2)
        mass_data(:,q) =  temp_data(:,q).*mass_fraction';
        mass_data(:,q) = mass_data(:,q)./sum(mass_data(:,q));
    end
    All_mass_data{p} = mass_data;
    [l,p]=boundedline(1:12,smooth(mean(mass_data,2),...
        'moving'),std(mass_data,[],2)./size(mass_data,2),...
        'transparency', 0.3,'cmap',CT(p,:));
    p.FaceAlpha=0.5;l.Marker='o';l.MarkerSize=4;l.LineWidth=2;
box on;set(gca,'FontSize',16);set(gca, 'LineWidth', 2);
xlim([0.5 13.5]);xlabel('Mass fraction');ylabel('Probability')
end

%% For plotting time vs mers
% CT=cbrewer('qual', 'Paired',length(All_obs));
mass_fraction =  [1:12];
% mass_fraction =  ones(1,12);
All_mass_data={};
% mass_fraction =  ones(1,12);
for p=1:length(All_obs)
    temp_data = cell2mat(All_pred(p));
    mass_data=[];
    for q=1:size(temp_data,2)
        mass_data(:,q) =  temp_data(:,q).*mass_fraction';
        mass_data(:,q) = mass_data(:,q)./sum(mass_data(:,q));
    end
    All_mass_data{p} = mass_data;
    All_mass_data_mers(:,p) = mass_data;
end
CT=cbrewer('qual', 'Paired',20);
for j=1:12
    plot(time(6:end),smooth(smooth(All_mass_data_mers(j,6:end),'moving'),'moving'),...
        'o-','LineWidth',3,'MarkerSize',4,'Color',CT(j,:));hold on
end

set(gca,'FontSize',18);box on;
set(gca, 'LineWidth', 2)



