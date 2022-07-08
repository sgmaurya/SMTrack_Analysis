% % Copyright @ Rahul Roy Jan 2017 
% Modified code @ Satya Dec 2017
% routine to correct drift from movie (stack of images)
% Input movie.tif file 
% Output movieDC.tif file
% 
% use a moving average of 'Wndw' no. of frames and 'Ovlp' no. of overlap
% frames for estimate the drift
% runs the dftregistration on this averaged from Efficient subpixel image registration by
% cross-correlation (from [1] Manuel Guizar-Sicairos, Samuel T. Thurman,
% and James R. Fienup, "Efficient subpixel image registration algorithms," Opt. Lett. 33, 156-158 (2008).)

% ImageDriftCorrect2 uses imread in a loop to read the tiff file (modified
% from ImageDriftCorrect

function drift_correct_images_satya()

close all;
clear all

%% Uploading the files
% [FileName,PathName] = uigetfile('*.tif','Select .tif file to correct drift', 'MultiSelect', 'off');
% cd(PathName);
datafile=uipickfiles;
for iii=1:length(datafile)
    FileName=cell2mat(datafile(iii));
    
%frames = input('Enter Total no. of frames?');
% cd(PathName);
% Wndw = input('Enter Window size for averaging the stacks(in number of frames) '); if isemptcleary(Wndw) Wndw = 50; end
% Ovlp = input('Enter Overlap size between the pooled(averaged) stacks(in number of frames) '); if isempty(Ovlp) Ovlp = 25; end
Wndw =10; Ovlp =20;
if strcmpi(FileName(end-2:end),'tif')
    filename=char(FileName);
    strgcount = ['*** File  ' filename '  is being analysed'];
        disp(strgcount);
    tiff_info = imfinfo(FileName); % return tiff structure, one element per image
    nframes= numel(tiff_info);
   % tiff_stack = imread(FileName, 1) ; % read in first image
    
    ncol =tiff_info(1,1).Width;
    nrow =tiff_info(1,1).Height;
    
    imagearrfull = zeros(nrow,ncol,nframes);
    
    for ii = 1 : nframes
         imagearrfull(:,:,ii)  = imread(FileName, ii, 'Info', tiff_info);
    end
    
          
   % imagesize= size(images{1});
   % imagearrfull=reshape(cell2mat(images), imagesize(1), imagesize(2), nframes);
else
    disp('Incorrect filetype');
end


%% Averaging of the stacks to generate images for registration


subimageframes = ceil(nframes/Ovlp);  %no of frames to utilize for calculating the drift along the movie
output = movmean(imagearrfull,Wndw,3); % moving average of stacks with Wndw frames
fr = floor(linspace(1,nframes,subimageframes));
subimage = output(:,:,fr); %subimage will be used for registration between neighbouring frames

%% Image registration between neighbouring subimage frames
regst = zeros(subimageframes,4);
usfac = 100;

for u = 2:subimageframes
     regst(u,:) = dftregistration(fft2(subimage(:,:,u-1)),fft2(subimage(:,:,u)),usfac);
end

%% Extrapolate to generate the drift correction array
frmarray = 1:1:nframes;
regstfullstart = zeros(nframes,4);
regstori = cumsum(regst,1);         % drift wrt to the first frame
%interplolate to get the drift for all frames
for h = 1:4
regstfullstart(:,h) = interp1(fr,regstori(:,h),frmarray,'pchip');
end

%% Plotting the the frame wise drift and phase changes

% subplot(1,2,1);
% imagesc(imagearrfull(:,:,5));
% title('Reference image ')
% subplot(1,2,2);
% imagesc(subimage(:,:,41));
% title('Averaged image')
% 
% figure;
% subplot(1,2,1);
% plot(fr,regstori(:,2),'*b');
% title('Phase change image stack ')
% subplot(1,2,2);
% plot(fr,regstori(:,3),'or', fr,regstori(:,4),'ok');
% title('Drfit image stack, red x, black y');
% 
% hold on;
% subplot(1,2,1);
% plot(frmarray,regstfullstart(:,2),'b');
% %title('Phase change image stack ')
% subplot(1,2,2);
% plot(frmarray,regstfullstart(:,3),'r', frmarray,regstfullstart(:,4),'k');
% %title('Drfit image stack, red x, black y');
% hold off;

%% Applying the correction to all movie images 
% create new array for drift correction
imageC = zeros(nrow,ncol, nframes);
nr=nrow;
nc=ncol;
Nr = ifftshift((-fix(nr/2):ceil(nr/2)-1));
Nc = ifftshift((-fix(nc/2):ceil(nc/2)-1));
[Nc,Nr] = meshgrid(Nc,Nr);

%fI = fft2(imagearrfull(:,:,1));

for f = 1:nframes
    imageC(:,:,f) = ifft2(fft2(imagearrfull(:,:,f)).*exp(-1i*2*pi*(regstfullstart(f,3)*Nr/nr+regstfullstart(f,4)*Nc/nc))).*exp(1i*regstfullstart(f,2));
end


%% save as a tiff file
filenomo = strcat(filename(1:end-4), 'C.tif');
imwrite(uint16(imageC(:,:,1)),filenomo);

for j=1:nframes
filenomo = strcat(filename(1:end-4), 'C.tif');

imwrite(uint16(imageC(:,:,j)),filenomo,'tif','WriteMode','append');

end

% for f =2:nframes
%     L0=imageC(:,:,f);
%     L1 = uint16(L0);
%     imwrite(L1,filenomo,'tif','writeMode','append');
%     
% %         imwrite((imageC(:,:,f)),filenomo,'tif','WriteMode','append');
% end


% for f =2:nframes
%     L0=imageC(:,:,f);
%     L1 = uint16(L0);
%     
%     imwritetiff( L1, filenomo, 'compression', 'none', 'writeMode', 'a')
% 
%     
% %         imwrite((imageC(:,:,f)),filenomo,'tif','WriteMode','append');
% end


end