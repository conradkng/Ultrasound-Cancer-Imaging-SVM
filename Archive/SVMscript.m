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

%% Set directories
% Path to SVM files
addpath('D:\WOrk\459Code\Analysisnew\SVMLibrary');
class1Dir = 'D:\WOrk\459Code\Analysisnew\f1';
class2Dir = 'D:\WOrk\459Code\Analysisnew\f2';
% Notes:
% - don't include spaces in path name
% - don't include \ at end of path

%% Load in the matricies
disp('Loading the features...');

numFiles = 4;


%% Loading features
[undampedC1Features, undampedC2Features] = loadsvmKSHEN(class1Dir, class2Dir, numFiles);
% Normalization
for j=1:9
    minimum = min(undampedC1Features(:,j));
    range = (max(undampedC1Features(:,j))-minimum);
    undampedC1Features(:,j) = (undampedC1Features(:,j) -minimum ) ./ range;
    
    minimum = min(undampedC2Features(:,j));
    range = (max(undampedC2Features(:,j))-minimum);
    undampedC2Features(:,j) = (undampedC2Features(:,j) -minimum ) ./ range;
end

%% SVM
c=1;
g=1/9;
% class 1 is labeled 1 and class 2 is labeled 2
label_train = vertcat( ones(size(undampedC1Features,1),1), 2*ones(size(undampedC2Features,1),1) );
data_train = vertcat( undampedC1Features, undampedC2Features);

%% Not using built-in cross validation function
% TESTSIZE hardcoded for now
TESTSIZE = 360;
storage_l = label_train;
storage_d = data_train;
STRING = sprintf( '-c %d -g %d -b 1' ,c,g);
results = struct('predictLabels',[], 'accuracies', [], 'probEstimates', []);
for i=1:numFiles
    %% Splitting into training and testing sets manually
    label_test = vertcat( label_train(TESTSIZE*(i-1)+1:TESTSIZE*i),label_train(TESTSIZE*(i+numFiles-1)+1:TESTSIZE*(numFiles+i)) );
    data_test = vertcat( data_train(TESTSIZE*(i-1)+1:TESTSIZE*i,:),data_train(TESTSIZE*(i+numFiles-1)+1:TESTSIZE*(numFiles+i),:) );
    % hack, we remove TESTSIZE # elements then the index to remove is
    % TESTSIZE # less
    label_train(TESTSIZE*(i-1)+1:TESTSIZE*i)=[];label_train(TESTSIZE*(i+numFiles-1-1)+1:TESTSIZE*(numFiles+i-1))=[];
    data_train(TESTSIZE*(i-1)+1:TESTSIZE*i,:)=[];data_train(TESTSIZE*(i+numFiles-1-1)+1:TESTSIZE*(numFiles+i-1),:)=[];
    % shuffles matrix rows around
    perm = randperm(size(label_train,1));
    label_train = label_train(perm,:);
    data_train = data_train(perm,:);
    %% Hack that swaps training and testing sets: train on 1 versus train on
    % rest
%     temp_label = label_train;
%     temp_data = data_train;
%     label_train = label_test;
%     data_train = data_test;
%     label_test = temp_label;
%     data_test = temp_data;
    % End of hack
    %% Training and Testing
    model = svmtrain(label_train, data_train, STRING);
    [predict_label, accuracy, prob_estimates] = svmpredict(label_test, data_test, model,'-b 1');
    results.predictLabels{i} = predict_label;
    results.accuracies{i} = accuracy;
    results.probEstimates{i} = prob_estimates;
    % reset
    label_train = storage_l;
    data_train = storage_d;
end
