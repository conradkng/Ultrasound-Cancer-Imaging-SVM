function [C1Features]  = loadsvmVisu(C1Dir, numFiles)

C1Files = dir(fullfile(C1Dir,'*.mat'));   % list all *.xyz files
C1Files = {C1Files.name}';                      % file names

if (numFiles ~= length(C1Files))
    disp('Warning, number of files input does not match \nthe legnth of the files in the directory');
    return
end

% Initialize full C1 feature matrix
% C1Features = zeros(numRowsInFeatureDat, numColumnsInFeatureDat, numFiles);
C1Features = [];
for i=1:numFiles
    fname = fullfile(C1Dir,C1Files{i}); 
    temp = load(fname);
    % resizedFeatures is the hardcoded name of the saved feature matrix
    temp = temp.resizedFeatures;
    C1Features(:, :, i) = temp;
    % C1Features = vertcat(C1Features,temp);
end

end

