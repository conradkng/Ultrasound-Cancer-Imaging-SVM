
%% HIGUCHI
% a = randi(10, 3,3,10,5); % N x M x T x K
% b = permute(a, [1 3 2 4]); % N x T x M x K
% 
% want = [higuchi(a(1,1,:,1),5); higuchi(a(2,1,:,1), 5)];
% 
% get = cellfun(@(x) higuchi(x,5), num2cell(b,2), 'uni', 0 ); % get higuchi 
% c = permute(cell2mat(get), [1 3 2 4]);
% CRUSHED

%% Regression
a = randi(10, 3,3,10,5); % N x M x T x K
b = permute(a, [1 3 2 4]); % N x T x M x K

want = [regression(squeeze(a(1,1,:,1))); regression(squeeze(a(2,1,:,1)))];

get = cellfun(@(x) regression(squeeze(x')), num2cell(b,2), 'uni', 0 ); % get higuchi 
c = squeeze(permute(cell2mat(get), [1 3 2 4]));

intercepts = c(1:2:end, :, :);
slopes = c(2:2:end, :, :);