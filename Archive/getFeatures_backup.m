function features = getFeatures(data)

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
    
    features = zeros(N, M, K, 9);
    data = data - repmat(mean(data,3), 1, 1, T, 1);

    hammingVector = hamming(T, 'periodic');
    hammingWindow = repmat(hammingVector, 1, N, M , K);
    hammingWindow = permute(hammingWindow, [2, 3, 1, 4]);

    data = data.*hammingWindow;

    n = 2^nextpow2(T);
    spectrum = abs(fft(data, n, 3)/n);
    spectrum = spectrum(:, :, 1:n/2, :); % technically should be 1:n/2+1, but it makes splitting the spectrum into 4 regions not fun
    % if there was a frequency axis: f = Fs*(0:(n/2))/n; ~ something like this
    
    % Create the first four features. Divide the spectrum into 4 regions 
    % and take the average (divide by total number of pixels in ROI) 
    % to get 1 spectrum per ROI.
    %        N' M' K' F'
    features(:, :, :, 1) = squeeze(mean(spectrum(:, :, 1:n/8, :), 3));
    features(:, :, :, 2) = squeeze(mean(spectrum(:, :, (1+n/8):(n/8)*2, :), 3));
    features(:, :, :, 3) = squeeze(mean(spectrum(:, :, (1+n/8*2):(n/8)*3, :), 3));
    features(:, :, :, 4) = squeeze(mean(spectrum(:, :, (1+n/8*3):(n/8)*4, :), 3));
     
    
    % Create features 5 and 6. These features are found by fitting a line
    % to the spectrum data and calling the slope and y-intercept features 5
    % and 6 respectively.
    regDat = permute(spectrum, [1 3 2 4]);
    regDat = cellfun(@(x) regression(squeeze(x')), num2cell(regDat,2), 'uni', 0 ); % map() hack
    regDat = squeeze(permute(cell2mat(regDat), [1 3 2 4]));

    features(:,:,:,5) = regDat(1:2:end, :, :);
    features(:,:,:,6) = regDat(2:2:end, :, :);
    
    % HIGUCHI
    higuchiMat = permute(data, [1 3 2 4]);
    higuchiMat = cellfun(@(x) higuchi(x, floor(T/2)), num2cell(higuchiMat,2), 'uni', 0); % map() hack 
    higuchiMat = squeeze(permute(cell2mat(higuchiMat), [1 3 2 4]));
    
    features(:, :, :, 7) = higuchiMat(:, : , :);

end

