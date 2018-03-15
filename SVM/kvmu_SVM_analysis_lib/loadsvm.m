function [featuresStruct] = loadsvm(C1Dir, C2Dir, numFiles, numRowsInFeatureDat, numColumnsInFeatureDat)

C1Files = dir(fullfile(C1Dir,'*.mat'));   % list all *.xyz files
C1Files = {C1Files.name}';                      % file names

C2Files = dir(fullfile(C2Dir,'*.mat'));   % list all *.xyz files
C2Files = {C2Files.name}';                      % file names

if numFiles ~= length(C1Files)
    error('Number of files input does not match the legnth of the files in the directory.');
else
    
    % Initialize full C1 feature matrix
    C1Features = zeros(numRowsInFeatureDat, numColumnsInFeatureDat, numFiles);
    C2Features = zeros(numRowsInFeatureDat, numColumnsInFeatureDat, numFiles);

    for i=1:numFiles
        temp = load(C1Files{i});
        C1Features(:, :, i) = temp.resizedFeatures;
    
        temp = load(C2Files{i});
        C2Features(:, :, i) = temp.resizedFeatures;
    end

    featuresStruct = struct('C1Features', C1Features, 'C2Features', C2Features);
end

