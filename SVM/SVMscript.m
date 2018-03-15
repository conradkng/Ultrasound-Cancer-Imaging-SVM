%% Info
%{
Last updated 3/14/2016 2:42 P.M. @kvmu

This script calculates the classification accuracy using the SVM
classifier for the features extracted by the runME.m script.

At the end of the script the classification accuracy vector will
be saved in a directory of your choice.

The way it works is that it will take (explain later):

# March 30 2016
Upgrade: Can now drop out features by setting the vector 'dropOut'
%}

clc
clear all
close all

%% data directories

undamped_noNoise_Dir = 'D:\WOrk\459Code\Analysisnew\459analysis\features\Undamped_No_Noise_Features';
damped_noNoise_Dir = 'D:\WOrk\459Code\Analysisnew\459analysis\features\Damped_No_Noise_Features';

undamped_noise_Dir = 'D:\WOrk\459Code\Analysisnew\459analysis\features\Undamped_Noise_Features';
damped_noise_Dir = 'D:\WOrk\459Code\Analysisnew\459analysis\features\Damped_Noise_Features';

% Notes:
% - don't include spaces in path name
% - don't include \ at end of path
addpath('D:\WOrk\459Code\Analysisnew\SVMLibrary');
outputDir = 'D:\WOrk\459Code\Analysisnew\459analysis\Results\oldData\'; %need \ here

% get all the experiment directories
[undamped_noNoise_C1, undamped_noNoise_C2] = getFolders(undamped_noNoise_Dir);
[damped_noNoise_C1, damped_noNoise_C2] = getFolders(damped_noNoise_Dir);
[undamped_noise_C1, undamped_noise_C2] = getFolders(undamped_noise_Dir);
[damped_noise_C1, damped_noise_C2] = getFolders(damped_noise_Dir);

%% script paramaters
numFiles = 5;
C = 1;
gamma = 1/9.0;
numRows = 360;
numCols = 9;
params = [numFiles, C, gamma, numRows, numCols];

numSets_noNoise = 12;
numSets_noise = 8;
dropOut = [];

%% magic happens here
h = waitbar(0,'Starting Analysis...');
for j = 1:numSets_noNoise
    %% undamped no noise
    currentC1Dir = undamped_noNoise_C1{j};
    currentC2Dir = undamped_noNoise_C2{j};
    
    applySVM('Undamped No-noise', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'undamped_noNoise\'));
    
    %% damped no noise
    currentC1Dir = damped_noNoise_C1{j};
    currentC2Dir = damped_noNoise_C2{j};
    
    applySVM('Damped No-noise', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'damped_noNoise\'));
    waitbar(j/(numSets_noNoise+numSets_noise),h,['Processing No Noise ' num2str(round(j/(numSets_noNoise+numSets_noise) * 100)) '%'])
end

for j = 1:numSets_noise
    %% undamped noise
    currentC1Dir = undamped_noise_C1{j};
    currentC2Dir = undamped_noise_C2{j};
    
    applySVM('Undamped Noise', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'undamped_noise\'));
    
    %% damped no noise
    currentC1Dir = damped_noise_C1{j};
    currentC2Dir = damped_noise_C2{j};
    
    applySVM('Damped Noise', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'damped_noise\'));
    waitbar((j+numSets_noNoise)/(numSets_noNoise+numSets_noise),h,['Processing No Noise ' num2str(round((j+numSets_noNoise)/(numSets_noNoise+numSets_noise) * 100)) '%'])
end

close(h)
clear all
uiwait(msgbox('End of SVM Analysis. Please check the output directory for the files.'));














