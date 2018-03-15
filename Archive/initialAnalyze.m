function result = initialAnalyze(data)

% extractFeatures: 
% Extracts the 9 features from the signal region of the data.

%   Inputs:: 
%           data: A 4-D Matrix (N x M x T x K) 
%           N = axial ROI (region of interest) indicies
%           M = lateral ROI indices
%           T = temporal ROI indices
%           K = region number  

%   Outputs:: 
%           features: A 4-D Matrix containing features (N' x M' x F')
%                     these features will have been averaged over the
%                     temporal/frequency domain, but no spatial average
%                     has been calculated.

%           N' = axial ROI (region of interest) indicies = N
%           M' = lateral ROI indices = M
%           F' = feature number (9 total):
%                          
%           F' = 1-4: spectrum average (temporal) in the four quarters of frequncy
%           F' = 5-6: intercept and slope of regression line to the sepctrum
%           F' = 7  : fractal dimension
  
    [N, M, T, K] = size(data);
    
    result = zeros(N, M, K, 9);
    data = data - repmat(mean(data,3), 1, 1, T, 1);

    hammingVector = hamming(T, 'periodic');
    hammingWindow = repmat(hammingVector, 1, N, M , K);
    hammingWindow = permute(hammingWindow, [2, 3, 1, 4]);

    data = data.*hammingWindow;
    
    FFTpoints = T - mod(T,8); % FFTpoints should be divisble by 8
    spectrum = abs(fft(data, FFTpoints, 3));
    spectrum = spectrum(:, :, 1:FFTpoints/2, :); 
    
    % Create features 5 and 6. These features are found by fitting a line
    % to the spectrum data and calling the slope and y-intercept features 5
    % and 6 respectively.
    regDat = permute(spectrum, [1 3 2 4]);
    regDat = cellfun(@(x) regression(squeeze(x')), num2cell(regDat,2), 'uni', 0 ); % map() hack
    regDat = squeeze(permute(cell2mat(regDat), [1 3 2 4]));

    result(:,:,:,5) = regDat(1:2:end, :, :);
    result(:,:,:,6) = regDat(2:2:end, :, :);
    
    % HIGUCHI
    higuchiMat = permute(data, [1 3 2 4]);
    higuchiMat = cellfun(@(x) higuchi(x, floor(FFTpoints/2)), num2cell(higuchiMat,2), 'uni', 0); % map() hack 
    higuchiMat = squeeze(permute(cell2mat(higuchiMat), [1 3 2 4]));
    
    result(:, :, :, 7) = higuchiMat(:, : , :);

end

