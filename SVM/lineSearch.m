clc
clear all
close all

%% Hyper parameters
numFiles = 5;
CMin = 1/9;
gammaMin = (1/9.0)/9;
outputDir = 'D:\WOrk\459Code\Analysisnew\459analysis\testing\';

%% Loop Parameters
h = waitbar(0,'Starting line search');
i_iter = 5;
j_iter = 5;
%% Search Loop
for i=1:i_iter
    for j=1:j_iter
        % set directories
        outDir = [outputDir 'i' num2str(i) 'j' num2str(j) '\'];
        mkdir(outDir);
        mkdir([outDir 'damped_noise']);
        mkdir([outDir 'damped_noNoise']);
        mkdir([outDir 'undamped_noise']);
        mkdir([outDir 'undamped_noNoise']);
        % set hyper parameters
        C = CMin*3^(i-1);
        gamma = gammaMin*3^(j-1);
        % write hyper parameters to file for record
        fileID = fopen([outDir 'param.txt'],'w');
        fprintf(fileID,[num2str(C) ' ' num2str(gamma)]);
        fclose(fileID);
        % classify
        scriptFunc(numFiles, C, gamma, outDir);
        waitbar(((i-1)*j_iter+j)/(i_iter*j_iter),h,['Line Search Progress ' num2str(round(((i-1)*j_iter+j)/(i_iter*j_iter)) * 100) '%']);
    end
end

close(h)
