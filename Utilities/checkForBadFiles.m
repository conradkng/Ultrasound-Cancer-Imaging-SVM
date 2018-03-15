clc
clear all
close all

%% Choose directories
inputDir = 'D:\WOrk\459Code\Analysisnew\input';     %# folder path
outputDir = 'D:\WOrk\459Code\Analysisnew\output'; 
% don't include spaces cuz spaces are sketch
% don't include slash at end of path

files = dir( fullfile(inputDir,'*.mha') );   %# list all *.xyz files
files = {files.name}';                      %'# file names
numFiles = size(files,1);

%% Analysis
disp('Beginning Analysis ...');
startTime = tic;
figure
hold on;
for i=1:numel(files)
    runStartTime = tic;
    fname = fullfile(inputDir,files{i});     %# full path to file
    % 9 is just ASCII for \t (tab)
    disp(['Unpacking file ...' 9 fname]);
    % do stuff
    RF_DATA = mha_read_volume(fname);
    RF_DATA = double(RF_DATA.pixelData);
    try
        % 1301 to 1820 for 3cm
        RF_DATA = RF_DATA(1301:1820, 1:252, 1:150);
        x = mean(RF_DATA,2);
        x = mean(x,1);
        x = squeeze(x);
        x = 10*(x-mean(x));
        x = abs(x);
        x = 10.^(x);
        plot(x)
        maxx(i) = max(abs(x));
    catch
       disp('ERROR: One of the dimensions in the data matrix is too small ... ');
       disp(['ERROR: Skipping file '  9 fname]);
       continue;
    end
end
legend('Location','best')