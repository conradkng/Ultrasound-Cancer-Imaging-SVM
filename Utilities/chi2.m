Observed = [99.306 98.611 99.722 98.750 99.861];
Expect = 99.250;
Expected = Expect*ones(1,5);
OmE2 = (Observed-Expected).^2;
chiSq = sum(OmE2./Expected);

C1Dir = 'D:\WOrk\459Code\Analysisnew\chi2\old_experiments_clean\damped_noise';
C1Files = dir(fullfile(C1Dir,'*.txt'));   % list all *.xyz files
C1Files = {C1Files.name}';
numFiles = length(C1Files);

for i=1:numFiles
    fname = fullfile(C1Dir,C1Files{i}); 
    temp = dlmread(fname);
end
