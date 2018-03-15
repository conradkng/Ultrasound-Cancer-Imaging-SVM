function [C1Features, C2Features]  = loadsvmKSHEN(C1Dir, C2Dir, numFiles)

C1Files = dir(fullfile(C1Dir,'*.mat'));   % list all *.xyz files
C1Files = {C1Files.name}';                      % file names

C2Files = dir(fullfile(C2Dir,'*.mat'));   % list all *.xyz files
C2Files = {C2Files.name}';                      % file names
if (numFiles ~= length(C1Files))
    disp('Warning, number of files input does not match \nthe legnth of the files in the directory');
    return
end

% Number of rows in the feature matrix
numRowsInFeatureDat = 360;

% Number of columns in the feature matrix
numColumnsInFeatureDat = 9;

% Initialize full C1 feature matrix
% C1Features = zeros(numRowsInFeatureDat, numColumnsInFeatureDat, numFiles);
% C2Features = zeros(numRowsInFeatureDat, numColumnsInFeatureDat, numFiles);
C1Features = [];
C2Features = [];
for i=1:numFiles
    fname = fullfile(C1Dir,C1Files{i}); 
    temp = load(fname);
    % resizedFeatures is the hardcoded name of the saved feature matrix
    temp = temp.resizedFeatures;
    % C1Features(:, :, i) = temp;
    C1Features = vertcat(C1Features,temp);
    
    fname = fullfile(C2Dir,C2Files{i}); 
    temp = load(fname);
    temp = temp.resizedFeatures;
    % C2Features(:, :, i) = temp;
    C2Features = vertcat(C2Features,temp);
end

end

