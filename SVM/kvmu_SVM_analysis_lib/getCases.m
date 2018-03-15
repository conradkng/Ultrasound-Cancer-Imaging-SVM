function [c1str, c2str] = getCases(C1Dir, C2Dir)
%GETCASES Summary of this function goes here
%   Detailed explanation goes here

    split_1 = strsplit(C1Dir, '\');
    split_2 = strsplit(C2Dir, '\');
    c1str = split_1{length(split_1)};
    c2str = split_2{length(split_2)};
end

