
function traces =traces2v1(data, filename, imagearr, denoisedimage)

% calculates the gaussian weighted average of point object based centroids provided for a stack of tiff images 
% calculates the background around every peak for every frame and
% substracts that from the summed internsity of molecule
% scaling of non-uniformly illuminated image to create similar illumination introduced

sizeofdata = size(data);
[x,y,nframes] = size(imagearr);
traces = [sizeofdata(1), nframes];
spotxy = round(data);

h2 = fspecial('gaussian', 100, 20);

 % Scaling of the images
           
            scimage = imdilate(denoisedimage, strel('disk',15));
            scimage2 = imfilter(scimage, h2);
            %imagesc(scimage2);
            
             

% denoising and background substraction of the image
disp('Denoising images');
for i = 1:nframes
   imagearr(:,:,i) = (imagearr(:,:,i)./scimage2) * max(max(scimage2));
    background = imopen(imagearr(:,:,i),strel('disk',15));
    imagearr(:,:,i) = imagearr(:,:,i) -imfilter(background, h2);
    imagearr(:,:,i) = imagearr(:,:,i) - imopen(imagearr(:,:,i),strel('disk',5)); 
    
    [meQ, seQ] = image_background(imagearr(:,:,i));
    imagearr(:,:,i) = imagearr(:,:,i) - meQ;
end

% gaussian weight matrix
WtMat= fspecial('gaussian', 5, 1);

for j = 1: sizeofdata(1)
    if spotxy(j,1)>4 && spotxy(j,1)< (y-4) && spotxy(j,2)>4 && spotxy(j,2)< (x-4)
    ROI = imagearr((spotxy(j,2)-2):(spotxy(j,2)+2), (spotxy(j,1)-2):(spotxy(j,1)+2), :); % ROI (5x5) around the peak selected
  %  ROIbkg = imagearr((spotxy(j,2)-5):(spotxy(j,2)+5), (spotxy(j,1)-5):(spotxy(j,1)+5), :); % ROI (11x11 pixels) selected for background
     %   strw = ['Molecule No. ' num2str(j) ' x= ' num2str(spotxy(j,1)) ' y= ' num2str(spotxy(j,2))];
 %   disp(strw);
    else
        ROI = [];
    end
    
    moleculebundle = 10;
            
    if mod(j, moleculebundle) == 0
    Counter = strcat('Working of Molecule #', num2str(j)); 
    disp(Counter);
    end
    
    if ~isempty(ROI)
    for i = 1:nframes
    traces(j,i) = sum(sum(WtMat.*ROI(:,:,i)));
    end
    else
   
    stre = ['Molecule No.' num2str(j) ' x= ' num2str(spotxy(j,1)) ' y= ' num2str(spotxy(j,2))  ' not selected'];
    disp(stre);
    end

end    

   %tx = find(~isnan(Rdata(:,10)));
    %Rdata = Rdata(tx,:);
   filenomo = strcat(filename, '.dat');
    filenome = strcat(filename, '.mat');

   save(filenomo, 'traces', '-ascii', '-tabs');
   save(filenome, 'traces');

end

