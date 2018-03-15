function applySVM(table_type, params, C1Dir, C2Dir, outputDir, dropOut)
%APPLYSVM Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 6
        dropOut = 0;
    end

    numFiles = params(1);
    C = params(2);
    gamma = params(3);
    numRows = params(4);
    numCols = params(5);
    
    [case1_str, case2_str] = getCases(C1Dir, C2Dir);
    fname = strcat(table_type, '_', case1_str ,...
                    '_', case2_str, '.txt');    
 
    fprintf('%s: Classifying %s against %s\n', table_type, case1_str, case2_str);
    
    results = classifyFeatures(C1Dir, C2Dir, numFiles, numRows, numCols, C, gamma, dropOut);
    outputResults(results, fname, outputDir, numFiles);

    avgResult = 0;
    for i=1:numFiles
        avgResult = avgResult + results.accuracies{i}(1);
    end

    avgResult = avgResult/5

end

