function outputResults(results, fname, outputDir, numFiles)
%OUTPUTRESULTS Summary of this function goes here
%   Detailed explanation goes here

result_vec = zeros(1, numFiles);

for i=1:numFiles
    result_vec(i)= results.accuracies{i}(1);
end

printArr = [1:numFiles; result_vec];

% ChiSquared
Observed = result_vec;
Expect = mean(result_vec);
Expected = Expect*ones(1,5);
OmE2 = (Observed-Expected).^2;
chiSq = sum(OmE2./Expected);

fileID = fopen(strcat(outputDir, fname),'w');
fprintf(fileID,'%s\t%s\n\n','Trial Number','Classification Accuracy (%)');
fprintf(fileID,'%d\t%0.3f\n', printArr);
fprintf(fileID,'Average: %0.3f\n', mean(printArr(2,:)));
fprintf(fileID,'ChiSquared: %0.3f\n', chiSq);
fclose(fileID);
end

