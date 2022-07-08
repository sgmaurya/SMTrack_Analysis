% Copyright @Rahul Feb10 2012

% called by Extract_traces_1C
% analyses the movie images
% needs load_images4, image_background
% implicitly assumes that the image comprises of certain region


function extracttraces_images(filename, SNR, hdl2)

      fname=filename(1:end-4);
      str = [ 'Filename: ' fname];
      disp(str);
      images = load_images4(filename);
      nframes= length(images);
      imagesize= size(images{1});
      imagearrfull=reshape(cell2mat(images), imagesize(1), imagesize(2), nframes);
    
 % this section selects a subsection (ROI) of the image analysis (remove
 % this if you want to analysis the complete image)
%  imagearr = imagearrfull(10:250,1:40,:);
  imagearr = imagearrfull(20:end-20,20:end-20,:);
%  imagearr = imagearrfull;
 % This section calculates the number of frames to use for creating the Z-
 % projection
%  naveframes = ceil(nframes/100);
%  t=20+naveframes;
 imageave = mean(imagearr(:, :,:), 3);
%  imageave = mean(imagearr(:, :,:), 3); %PV
      
%       h = fspecial('gaussian', 2, 2); % PV
      h = fspecial('gaussian', 2, 2);
      h2 = fspecial('gaussian', 100, 20);


        % Display the average image 
      figure(hdl2);
        imagesc(imageave); colormap gray;
  
            % Denoising by background substraction and weiner filter
             background = imopen(imageave,strel('disk',15));
             imageave = imageave -imfilter(background, h2);
             %imageave = imageave -background;
             denoisedimage = imageave - imopen(imageave,strel('disk',5));
             denoisedimage = imfilter(denoisedimage,h);     % gaussian smoothing
             
            % images{j} = wiener2(images{j},[3 3]);
             
             %calculate background
             [meQ, seQ] = image_background(denoisedimage);
%           
             InsT = meQ+ SNR*seQ; % threshold defination SNR = 6
            
            %Incase there are no molecules or dim molecules (SNR<3), set
            %threshold above max pixel value so that no fitting is done
%                 if (InsT < (meQ + 3*seQ))
%                     InsT = maxQ + seQ;
%                 end 
            
            fitParams = struct( ...
            'curvatureThreshold',   50000, ...
            'intensityThreshold',   InsT, ...
            'windowSize',           5, ...
            'minWidth',             0, ...
            'maxWidth',             5, ...
            'angle',                -0 * pi/180 ... negative because imagesc displays the y-axis inverted
            );
             
             
            data = fit_spots1S(denoisedimage, fitParams);
 %           data{j} = fit_spots2S(denoisedimages{j}, 'gaussian', fitParams, data{j});
 

  hold on;
scatter(data(:,1), data(:,2), 'o', 'r');  
%  hold off;
         
    traces2v1(data,fname,imagearr, denoisedimage);
      
end     
   
      