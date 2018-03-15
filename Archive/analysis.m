%% Last updated 2/25/2016 2:21 P.M. @kvmu

% This script is intended to perform a simple spectrum analysis of data
% gathered from ultrasound phantom experiments.
% The input data is a 3D dimensional matrix: NxMxT, where:
 
% N = int(imaging depth [m]/axial resolution[m])
% M = transducer crystal number (width of transducer [m]/lateral resolution [m])
% T = the number of frames aquired (duration of experiment*fps).

% Function 1: Load RAW data / save .mat file
% Function 2 & 3: 
%             Define signal region (+/- 0.5cm focal region, in 4 quadrants)
%             Refine RF Data (keep points in signal region)

%% TO DO: UPDATE THE DESCRIPTION ABOVE


filename = 'D:\WOrk\459Code\Analysisnew\input\IO__RF_A4_LB_StepI.mha';
outputDir = 'D:\WOrk\459Code\Analysisnew\output';


RF_DATA = mha_read_volume(filename);
RF_DATA = double(RF_DATA.pixelData);

RF_DATA = RF_DATA(1301:1820, 1:252, 1:150); % given by Farhad -- constant?


% Extract the features using farhad's code
% the 7 and 52 make it so we have (1820-1301+1)/52 = 10 and (252-1+1)/7 =
% 36. So the total feature matrix size should correspond.
% The third argument is a kmax (for higuchi), I just make it half the
% length of the important dimension (which is time).
first_7_features = RF_Time_Series(RF_DATA, 7, 52, 150/2);
next_2_features = RF_Time_Series_wavelet_MCF(RF_DATA, 7, 52);

%%
features = cat(3,first_7_features, next_2_features);

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
outputDir = 'D:\WOrk\459Code\Analysisnew\output';
outFileName = strcat(outputDir,'\featureFile','featureFileIO__RF_A4_LB_StepI.mha','.mat');
save(outFileName,'resizedFeatures');
% So all the features are here now. The next step would be to loop over all
% .mha files in a directory -- also what should we do with the features? I
% was thinking saveing them as a .mat file in the same directory as where
% we read the data from. The command to save is simply:
% >> save features
% and a file called features.mat will be saved in the working directory.


% SOME EXAMPLE STUFF FOR LOOPING IN A DIRECTORY
%files = dir('*.mha');
%for file = files'
%    rf = mha_read_volume(file.name);
    % Do some stuff
%end