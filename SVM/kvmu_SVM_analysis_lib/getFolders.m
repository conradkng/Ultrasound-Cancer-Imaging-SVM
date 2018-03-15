function [case1, case2] = getFolders(start_path)
%GETFOLDERS Summary of this function goes here
%   Detailed explanation goes here

allSubFolders = genpath(start_path);

% Scan through them separating them.
remain = allSubFolders;
listOfFolderNames = {};
while true
[singleSubFolder, remain] = strtok(remain, ';');
if isempty(singleSubFolder), break; end
listOfFolderNames = [listOfFolderNames singleSubFolder];
end

listOfFolderNames = listOfFolderNames(2:end);
case1 = listOfFolderNames(2:3:end);
case2 = listOfFolderNames(3:3:end);
end

