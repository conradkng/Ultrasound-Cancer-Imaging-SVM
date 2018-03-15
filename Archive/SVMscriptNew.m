%% Info
%{
Last updated 3/14/2016 2:42 P.M. @kvmu

This script calculates the classification accuracy using the SVM
classifier for the features extracted by the runME.m script.

At the end of the script the classification accuracy vector will
be saved in a directory of your choice.

The way it works is that it will take (explain later):

%}

clc
clear all
close all

%% data directories

undamped_noNoise_Dir66 = 'D:\WOrk\459Code\Analysisnew\newFeatures\features\undamped_no_noise_features\6.6mhz-3powerundampednonoisefeaturefiles';
undamped_noNoise_Dir10 = 'D:\WOrk\459Code\Analysisnew\newFeatures\features\undamped_no_noise_features\10.0MHz0PowerUndampedNoNoiseFeatureFiles';

damped_noNoise_Dir66 = 'D:\WOrk\459Code\Analysisnew\newFeatures\features\damped_no_noise_features\6.6mhz-3powerdampednonoisefeaturefiles';
damped_noNoise_Dir10 = 'D:\WOrk\459Code\Analysisnew\newFeatures\features\damped_no_noise_features\10.0mhz0powerdampednonoisefeaturefiles';

undamped_noise_Dir66 = 'D:\WOrk\459Code\Analysisnew\newFeatures\features\undamped_noise_features\6.6mhz-3powerundampednoisefeaturefiles';
undamped_noise_Dir10 = 'D:\WOrk\459Code\Analysisnew\newFeatures\features\undamped_noise_features\10.0mhz0powerundampednoisefeaturefiles';

damped_noise_Dir66 = 'D:\WOrk\459Code\Analysisnew\newFeatures\features\damped_noise_features\6.6mhz-3powerdampednoisefeaturefiles';
damped_noise_Dir10 = 'D:\WOrk\459Code\Analysisnew\newFeatures\features\damped_noise_features\10.0mhz0powerdampednoisefeaturefiles';

% Notes:
% - don't include spaces in path name
% - don't include \ at end of path
addpath('D:\WOrk\459Code\Analysisnew\SVMLibrary');
outputDir = 'D:\WOrk\459Code\Analysisnew\newFeatures\Results\dropOuts\only9\'; %need \ here

% get all the experiment directories
[undamped_noNoise66_C1, undamped_noNoise66_C2] = getFolders(undamped_noNoise_Dir66);
[undamped_noNoise10_C1, undamped_noNoise10_C2] = getFolders(undamped_noNoise_Dir10);
[damped_noNoise66_C1, damped_noNoise66_C2] = getFolders(damped_noNoise_Dir66);
[damped_noNoise10_C1, damped_noNoise10_C2] = getFolders(damped_noNoise_Dir10);
[undamped_noise66_C1, undamped_noise66_C2] = getFolders(undamped_noise_Dir66);
[undamped_noise10_C1, undamped_noise10_C2] = getFolders(undamped_noise_Dir10);
[damped_noise66_C1, damped_noise66_C2] = getFolders(damped_noise_Dir66);
[damped_noise10_C1, damped_noise10_C2] = getFolders(damped_noise_Dir10);

%% script paramaters
numFiles = 3;
C = 1;
gamma = 1/9.0;
numRows = 360;
numCols = 9;
params = [numFiles, C, gamma, numRows, numCols];

numSets_noNoise = 4;
numSets_noise = 4;
dropOut = [1 2 3 4 5 6 7 8];

%% magic happens here
h = waitbar(0,'Starting Analysis...');
for j = 1:numSets_noNoise
    %% undamped no noise 6.6MHz
    currentC1Dir = undamped_noNoise66_C1{j};
    currentC2Dir = undamped_noNoise66_C2{j};
   
    applySVM('Undamped No-noise 66', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'undamped_noNoise66\'), dropOut);
    
    %% undamped no noise 10MHz
    currentC1Dir = undamped_noNoise10_C1{j};
    currentC2Dir = undamped_noNoise10_C2{j};
   
    applySVM('Undamped No-noise 10', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'undamped_noNoise10\'), dropOut);
    
    %% damped no noise 6.6MHz
    currentC1Dir = damped_noNoise66_C1{j};
    currentC2Dir = damped_noNoise66_C2{j};
    
    applySVM('Damped No-noise 66', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'damped_noNoise66\'), dropOut);
    
    %% damped no noise 10MHz
    currentC1Dir = damped_noNoise10_C1{j};
    currentC2Dir = damped_noNoise10_C2{j};
    
    applySVM('Damped No-noise 10', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'damped_noNoise10\'), dropOut);
    waitbar(j/(numSets_noNoise+numSets_noise),h,['Processing No Noise ' num2str(round(j/(numSets_noNoise+numSets_noise) * 100)) '%'])
end

for j = 1:numSets_noise
    %% undamped noise 6.6MHz
    currentC1Dir = undamped_noise66_C1{j};
    currentC2Dir = undamped_noise66_C2{j};
    
    applySVM('Undamped Noise 66', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'undamped_noise66\'), dropOut);
    
    %% undamped noise 10MHz
    currentC1Dir = undamped_noise10_C1{j};
    currentC2Dir = undamped_noise10_C2{j};
    
    applySVM('Undamped Noise 10', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'undamped_noise10\'), dropOut);
    
    %% damped no noise 6.6MHz
    currentC1Dir = damped_noise66_C1{j};
    currentC2Dir = damped_noise66_C2{j};
    
    applySVM('Damped Noise 66', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'damped_noise66\'), dropOut);
    
    %% damped no noise 10MHz
    currentC1Dir = damped_noise10_C1{j};
    currentC2Dir = damped_noise10_C2{j};
    
    applySVM('Damped Noise 10', params, currentC1Dir, currentC2Dir, strcat(outputDir, 'damped_noise10\'), dropOut);
    waitbar((j+numSets_noNoise)/(numSets_noNoise+numSets_noise),h,['Processing No Noise ' num2str(round((j+numSets_noNoise)/(numSets_noNoise+numSets_noise) * 100)) '%'])
end

close(h)
clear all
uiwait(msgbox('End of SVM Analysis. Please check the output directory for the files.'));














