%% Info
%{
Last updated 3/29/2016 2:42 P.M. @kvmu

This script plots 3 features in 3D space for visualization

The way it works is that it will take (explain later):

%}

% clc
% clear all
% close all

%% Set directories
% Path to SVM files
fileDir1 = 'D:\WOrk\459Code\Analysisnew\f1';
fileDir2 = 'D:\WOrk\459Code\Analysisnew\f2';

% Notes:
% - don't include spaces in path name
% - don't include \ at end of path

%% Load in the matricies
disp('Loading the features...');

numFiles = 5;


%% Loading features
[Features1] = loadsvmVisu(fileDir1, numFiles);
[Features2] = loadsvmVisu(fileDir2, numFiles);

%% Pick 3 features to plot
feats = [6 5 1];
plotFeats1 = Features1(:,feats,:);
plotFeats2 = Features2(:,feats,:);

%% Randomly knock out some data points to make graph more visually appealing
p = randperm(length(plotFeats1));
ratioToKeep = 0.20;
p = p(1:round(ratioToKeep*length(plotFeats1)));
plotFeats1 = plotFeats1(p,:,:);
plotFeats2 = plotFeats2(p,:,:);

figure('color','white');
hold on;
colormap jet;
for i=1:numFiles
    x1=plotFeats1(:,1,i);y1=plotFeats1(:,2,i);z1=plotFeats1(:,3,i);
    colRange = [1 2*numFiles];
    % You can specify color for each particular point so we make it same
    % for each file
    colParticular1 = 1.1*i*ones(length(plotFeats1),1);
    plot3k({x1 y1 z1},'ColorRange',colRange,'ColorData',colParticular1,'Plottype','scatter','FontSize',12,'Marker',{'o',3},'Labels',{['Visualization of features ' num2str(feats(1)) ', ' num2str(feats(2)) ', ' num2str(feats(3)) ' in Feature Space'],['Feature # ' num2str(feats(1))],['Feature # ' num2str(feats(2))],['Feature # ' num2str(feats(3))],'File #'});
end
for i=1:numFiles
    x2=plotFeats2(:,1,i);y2=plotFeats2(:,2,i);z2=plotFeats2(:,3,i);
    colRange = [1 2*numFiles];
    % You can specify color for each particular point so we make it same
    % for each file
    colParticular2 = (2*numFiles - i+1)*ones(length(plotFeats2),1);
    plot3k({x2 y2 z2},'ColorRange',colRange,'ColorData',colParticular2,'Plottype','scatter','FontSize',12,'Marker',{'x',5},'Labels',{['Visualization of features ' num2str(feats(1)) ', ' num2str(feats(2)) ', ' num2str(feats(3)) ' in Feature Space'],['Feature # ' num2str(feats(1))],['Feature # ' num2str(feats(2))],['Feature # ' num2str(feats(3))],'File #'});
end

legend('P1F1', 'P1F2', 'P1F3', 'P1F4', 'P1F5', 'P2F1', 'P2F2', 'P2F3', 'P2F4', 'P2F5')