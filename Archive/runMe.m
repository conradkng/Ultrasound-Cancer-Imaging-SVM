%% Info
%{
Last updated 3/12/2016 9:09 P.M. @kvsh

This script is intended to process all the .mha files in a folder and
output .mat files containing the features.

Instructions:
1. change "inputDir" variable to the directory containing the .mha files
2. change "outputDir" variable to the directory where you want to save .mha
   files
3. Hit run!
%}

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
        RF_DATA = RF_DATA(1301:1820, 1:252, 1:150); % given by Farhad -- constant?
    catch
       disp('ERROR: One of the dimensions in the data matrix is too small ... ');
       disp(['ERROR: Skipping file '  9 fname]);
       continue;
    end
    disp('Calculating first 7 features ... '); tic;
    first_7_features = RF_Time_Series(RF_DATA, 7, 52, 150/2);
    disp(['Time to calculate:', 9 int2str(toc) ' seconds']);
    disp('Calculating last 2 features ... '); tic;
    next_2_features = RF_Time_Series_wavelet_MCF(RF_DATA, 7, 52);
    disp(['Time to calculate:' 9 int2str(toc) ' seconds']);
    features = cat(3,first_7_features, next_2_features);    
    % save feature mat
    outFileName = strcat(outputDir,'\featureFile',files{i},'.mat');
    disp(['Saving features to file ...' 9 outFileName]); tic;
    % Resizing
    % column # = feature #
    % each column goes through 1 feature
    % Supposed feature 1 was    A B
    %                           C D
    % feature 1 now becomes:
    %   A
    %   B
    %   C
    %   D
    resizedFeatures = permute(features,[2 1 3]);
    resizedFeatures = reshape(resizedFeatures,[],size(features,3),1);
    save(outFileName,'resizedFeatures');
    disp(['Time Elasped:' 9 int2str(toc) ' seconds']);
    disp(['Total File Time:' 9 int2str(toc(runStartTime)) ' seconds']);
    disp(['Completed' 9 int2str(i) '\' int2str(numFiles) ' files ' 9 num2str(100*(i/numFiles)) '%']);
end
disp(['Total Time Elasped:' 9 int2str(toc(startTime)) ' seconds']);

