data=uipickfiles;
All_intensity={};
for iii=1:length(data)
    pool_output=cell2mat(data(iii));edit step
    cd((strcat(pool_output,'\','TrackingPackage','\','GaussianMixtureModels')));
    filename=(strcat(pool_output,'\','TrackingPackage','\','GaussianMixtureModels','\','Channel_1_detection_result.mat'));
    % r=load('Channel_1_tracking_result.mat');
    r=load(filename);
    v=r.movieInfo;
    xcord=floor(v.xCoord(:,1));
    ycord=floor(v.yCoord(:,1));
    [f1 f2 f3]=fileparts(pool_output);
    cd(f1);
    images = load_images4(f2(5:end));
    nframes= length(images);
    imagesize= size(images{1});
    imagearr=reshape(cell2mat(images), imagesize(1), imagesize(2), nframes);
    imageave = mean(imagearr(:,:,1:50), 3);

    h = fspecial('gaussian', 3, 1);
    h2 = fspecial('gaussian', 100, 20);

     % Denoising by background substraction and weiner filter
                 background = imopen(imageave,strel('disk',15));
                 imageave = imageave -imfilter(background, h2);
                 %imageave = imageave -background;
                 denoisedimage = imageave - imopen(imageave,strel('disk',5));
                 denoisedimage = imfilter(denoisedimage,h);     % gaussian smoothing  
    % denoising and background substraction of the image
    disp('Denoising images');
    for i = 1:nframes
      % imagearr(:,:,i) = (imagearr(:,:,i)./scimage2) * max(max(scimage2));
        background = imopen(imagearr(:,:,i),strel('disk',15));
        imagearr(:,:,i) = imagearr(:,:,i) -imfilter(background, h2);
        imagearr(:,:,i) = imagearr(:,:,i) - imopen(imagearr(:,:,i),strel('disk',5)); 

        [meQ, seQ] = image_background(imagearr(:,:,i));
        imagearr(:,:,i) = imagearr(:,:,i) - meQ;
    end

% gaussian weight matrix
WtMat= fspecial('gaussian', 7, 1.5);

for j = 1: length(ycord)
    if ycord(j)>4 && ycord(j)< (imagesize(1)-4) && xcord(j)>4 && xcord(j)< (imagesize(2)-4)
%         ROI = imagearr(round(ycord(j))-3:round(ycord(j))+3, round(xcord(j))-3:round(xcord(j))+3, :); % ROI (4x4) around the peak selected
        ROI = imagearr(round(ycord(j)), round(xcord(j)), :); % ROI 1 around the peak selected

        int(j,:) = sum(sum(WtMat.*ROI));
%         int(j,:) = sum(sum(WtMat.*ROI));
        %  ROIbkg = imagearr((spotxy(j,2)-5):(spotxy(j,2)+5), (spotxy(j,1)-5):(spotxy(j,1)+5), :); % ROI (11x11 pixels) selected for background
        %   strw = ['Molecule No. ' num2str(j) ' x= ' num2str(spotxy(j,1)) ' y= ' num2str(spotxy(j,2))];
        %   disp(strw);
    else
        ROI = [];
    end
    
end
All_intensity{iii}=int;
int=[];
  


end

stepcount=[];stepSize={};
 for kkk=1:length(All_intensity)
    traces = cell2mat(All_intensity(kkk));
    for jjj=1:size(traces,1)
        I1=traces(jjj,:);
        a=stepDetection(I1,10,2 ,20,5);
        stepcount(kkk,jjj)=(table2array(a(1,1)));
        stepSize{kkk,jjj}=(table2array(a(1,6)));
    end
 end   

save Stepcount.mat;
