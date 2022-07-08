%Code lets you load all **.tif files in a folder and use fit_spots to find centroids from an average image and then extract traces from those positions 
% rahul Nov 06, 2014


function Extract_traces_1C

close all;


%directory = uigetdir;
directory=input('Enter the file directory for analysis\n', 's');
cd(directory);
SNR = input('Enter the SNR for analysis\n');
A = getAllFiles(directory);
numberfiles=length(A);

inc=1;
n=1;



% InsT =input('Enter Intensity Threshold (default 400):');
% if isempty(InsT)
%    InsT=400;
% end
 hdl2 =figure();  
while (n<=numberfiles)
  
   filename = char(A(n));
   
if strcmpi(filename(end-2:end),'tif')  
    
    strgcount = ['*** File number  ' num2str(n) '  of  ' num2str(numberfiles) '  files'];
        disp(strgcount);
    
   extracttraces_images(filename, SNR, hdl2);
         
end
  n=n+inc;
end   %while

