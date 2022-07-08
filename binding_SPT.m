data=uipickfiles; % select one movie folder analyzed by uTrack
time_frame = 0.025; % INPUT

for iii=1:length(data)
pool_output=cell2mat(data(iii));
cd((strcat(pool_output,'\','TrackingPackage','\','GaussianMixtureModels')));
filename=(strcat(pool_output,'\','TrackingPackage','\','GaussianMixtureModels','\','Channel_1_detection_result.mat'));
% r=load('Channel_1_tracking_result.mat');
r=load(filename);
v=r.movieInfo;
v1=struct2cell(v);
C1=v1(2,:);
for k=1:length(C1)
    particle_no(k) = length(cell2mat(C1(k) ));
end
time=time_frame.*[1:length(C1)];    
end

scatter(time,particle_no,'filled');
clearvars -except data time particle_no
% time=time';particle_no=particle_no';
% g = fittype('a-b*exp(-x*c)');
% f0 = fit(time,particle_no,g,'StartPoint',[[ones(size(time)), -exp(-time)]\particle_no; 1]);
% 
% xx=linspace(1,time(end),100);
% plot(xx,f0(xx),'r-');