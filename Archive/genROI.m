function ROIs = genROI(rawData, focalDepth)

% genROI: 
% Creates a 4-D matrix (N x M x T x k) where k separates the regions
% of interest. This function assumes that the ultrasound transducer being
% utilised is L-14-5. The ROIs are defined as the region +- 0.5 cm from the
% focal depth, with a width of 0.1563 cm. There 32 such rectangular regions.


%   Inputs:: 
%           rawData: A 3-D Matrix (N x M x T) 
%           N = axial indices (imaging depth [m]/axial resolution[m])
%           M = lateral indicies; transducer crystal number (width of transducer [m]/lateral resolution [m])
%           T = temporal indices; the number of frames aquired (duration of experiment*fps).
%
%           focalDepth: The focal depth setting used in the experiment [m] 

%   Outputs:: 
%           ROIs: A 4-D Matrix (N' x M' x T' x K) 
%           N' = axial ROI indicies
%           M' = lateral ROI indices
%           T' = temporal ROI indices
%           K = region number             

% Probe specific paramaters (L-14-5)::
probeDepth = 0.14; % meters
probeWidth = 0.05; % meters (unused variable)
numCrystals = 256;

% User defined paramters
numRegions = 32; % keep this a power of 2
regionBoundary = numCrystals/numRegions;

% Find the size of the raw data
[axialDepth, ~, numFrames] = size(rawData);

% Find axial resolution
axialResolution = probeDepth/axialDepth;

% Find the index in rawData that corresponds to focalDepth
focalIndex = floor(focalDepth/axialResolution);

% Find the number of indices that correspond to a delta_x of 1 cm.
regionIndex = floor(0.005/axialResolution);

% Initialize ROIs matrix
ROIs = zeros(regionIndex*2+1, regionBoundary, numFrames, numRegions); 

% Construct the regions of interest and save them in ROIs
for i = 1:numRegions
    ROIs(:,:,:, i) = rawData((focalIndex-regionIndex):(focalIndex+regionIndex),...
                     1+(i-1)*regionBoundary:regionBoundary*i,:);
end 

end

