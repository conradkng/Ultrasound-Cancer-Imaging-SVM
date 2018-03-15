function RF = readRFfile(filename)
%
%readRFfile Read an RF file as a matrix and store it in a .mat file
%
%   RF = readRFfile(FILENAME)
%   FILENAME : name of the file to be read without the .rf extension
%   RF : output RF matrix with dimensions (RFsamples * LineNumber * Frames)
%

fname=strcat(filename,'.rf');

fileInfo = dir(fname);
fileSize = fileInfo.bytes;

fid = fopen(fname,'r');

numberOfTagsInHeader=19;
[tag1,~] = fread(fid,numberOfTagsInHeader,'int');
frames = tag1(2)
w = tag1(3)
h = tag1(4)

% For new RF files there is no id stored for each RF frame.
% Find out from the file size if it's a new or an old RF file.
if (fileSize == w*h*frames*2 + numberOfTagsInHeader*4)
    idAvailableForEachFrame=0;
elseif (fileSize == w*h*frames*2 + numberOfTagsInHeader*4 + frames*4)
    idAvailableForEachFrame=1;    
else
    disp('File size mismatch');
    return;    
end

% Read the raw data
RF = zeros(h,w,frames,'int16');
tag(frames)=0;

for frame_count = 1 : frames
    if (idAvailableForEachFrame)
        [tag(frame_count),~] = fread(fid,1,'int');
    end
    
    [v,~] = fread(fid,w*h,'short');

    RF(:,:,frame_count) = int16(reshape(v,h,w));
    %disp([frame_count tag(frame_count)]);
end

RFFrame = RF(:,:,1);
RFFrame = double(RFFrame);
%%%%%%%%%%%%
figure;
colormap(gray);
imagesc( log( abs( hilbert( double(RFFrame) ) ) )/1000.0);
figure;
colormap(gray);
Q1 = RF(500:1500, 10:120, 1);
Q2 = RF(1500:2000, 10:120, 1);
Q3 = RF(500:1500, 136:246, 1);
Q4 = RF(1500:2000, 136:246, 1);

imagesc( log( abs( hilbert( double(Q1) ) ) )/1000.0);
%%%%%%%%%%%%




save(strcat(filename,'.mat'),'RF');
fclose(fid);


tag1