function [results] = classifyFeatures(C1Dir, C2Dir, numFiles, numRowsInFeatureDat, numColumnsInFeatureDat, cFactor, gamma, dropOut)
    if nargin < 8
        dropOut = 0;
    end
    
    featureStruct = loadsvm(C1Dir, C2Dir, numFiles, numRowsInFeatureDat, numColumnsInFeatureDat);
    C1Features = featureStruct.C1Features;
    C2Features = featureStruct.C2Features;
    if ~isequal(dropOut,0)
        fprintf(['Dropping out features: ' num2str(dropOut) '\n']);
        C1Features(:,dropOut,:) = [];
        C2Features(:,dropOut,:) = [];
    end
    
    results = struct('predictLabels',[], 'accuracies', [], 'probEstimates', []);

    for i=1:numFiles
        testFeatures = vertcat(C1Features(:,:,i), C2Features(:,:,i));
        testFeatures = (testFeatures - repmat(min(testFeatures), length(testFeatures), 1))./...
                           (repmat(max(testFeatures), length(testFeatures), 1) -  ...
                            repmat(min(testFeatures), length(testFeatures), 1));

        testLabels = vertcat(ones(size(C1Features,1),1), 2*ones(size(C2Features,1),1));
        trainingFeatures = [];
        classLabels = [];
        for j=1:numFiles
            if i ~= j
                trainingFeatures = vertcat(trainingFeatures, vertcat(C1Features(:,:,j), C2Features(:,:,j)));
                classLabels = vertcat(classLabels, ones(size(C1Features,1),1), 2*ones(size(C2Features,1),1));
            end
        end

        trainingFeatures = (trainingFeatures - repmat(min(trainingFeatures), length(trainingFeatures), 1))./...
                            (repmat(max(trainingFeatures), length(trainingFeatures), 1) -  ...
                            repmat(min(trainingFeatures), length(trainingFeatures), 1));

        % shuffles matrix rows around
        perm = randperm(size(classLabels,1));
        classLabels = classLabels(perm,:);
        trainingFeatures = trainingFeatures(perm,:);
        
        %dummy = 'dwtf'
        %STRING = sprintf( '-c %d -g %d -b 1 -q -t 3' , cFactor,gamma);
        STRING = sprintf( '-c %d -g %d -b 1 -q' , cFactor,gamma);
    %     STRING = sprintf( '-c %d -g %d -b 1 -v %d' , cFactor, gamma, numFiles);
        model = svmtrain(classLabels, trainingFeatures, STRING);
        [predict_label, accuracy, prob_estimates] = svmpredict(testLabels, testFeatures, model,'-b 1');
        results.predictLabels{i} = predict_label;
        results.accuracies{i} = accuracy;
        results.probEstimates{i} = prob_estimates;

    end



end

