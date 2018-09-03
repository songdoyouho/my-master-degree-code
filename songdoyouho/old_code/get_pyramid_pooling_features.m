function [] = get_pyramid_pooling_features(data, saveName, pyramid_pooling_levels)
% GET_PYRAMID_POOLING_FEATURES Get Pyramid Pooling Features
%   [] = get_pyramid_pooling_features(data, saveName, pooling_levels)
%   Input:
%       pyramid_pooling_levels: ex:[1,2,3] will compute a 3 layers pyramid
%                               which comtains 2^0 + 2^1 + 2^2 parts.

%%
% ==============================================================================
% Filename: get_pyramid_pooling_features.m
% Project:  new_code
% Created: 	Oct 12, 2016
% Author:	Chao-Chuan Lu <luchaochuan@gmail.com>
% Description:
%           Get Pyramid Pooling Features. Pooling Operators are "sum" and
%           "max" pooling.
% ==============================================================================
% Change Log:
% Date			ID			Change Description
% ------------------------------------------------------------------------------
% Oct  12, 2016	CCL			Code created.
% Oct  22, 2016 CCL         Add Check function.
% ==============================================================================
%%
    %%  Check inputs
    if nargin < 3
        error('Function requires at least three inputs.');
    end
    
    %%  Compute Pyramid Pooling
    pooling_temp = cell(length(pyramid_pooling_levels),1);
    for level_num = 1:length(pyramid_pooling_levels)
        level = pyramid_pooling_levels(level_num);
        part_total = 2^(level - 1);
        
        % Compute Video Pyramids
        video_pyramid_temp = cell(length(data),part_total);
        for data_num = 1:length(data)
            video = data{data_num};
            % Compute index for video pyramids
                % length: data length
                data_length = size(video,1);
                % st/en: start/end of the frame index in one part
                st = floor(1:data_length/part_total:data_length);
                en = [st(2:end)-1, data_length];
                % Check if en is smaller than st
                for i=1:size(en,2)
                    if en(1,i) < st(1,i)
                       en(1,i) = st(1,i);
                    end
                end
                
                if size(st,2) < part_total
                    st = [st(1,1:size(st,2)) data_length*ones(1,part_total-size(st,2))];
                    en = [en(1,1:size(en,2)) data_length*ones(1,part_total-size(en,2))];
                end
            % Cut whole video into (part_total) parts
            for part_num = 1:part_total
                video_pyramid_temp{data_num, part_num} = video(st(1,part_num):en(1,part_num),:);
            end
        end
        
        % Compute Pooling
        max_pooling = cellfun(@max, video_pyramid_temp, 'UniformOutput', false);
        sum_pooling = cellfun(@mean, video_pyramid_temp, 'UniformOutput', false);
        
        % Check if the video is too short for pyramid(max and mean
        % function)!
        % If the video_pyramid_temp has any cell with size(1x200), it may
        % cause the max and mean function output with ONLY one result
        % instead of normal result(1x200).
        for i = 1:size(video_pyramid_temp,1)
            for j = 1:size(video_pyramid_temp,2)
                if length(max_pooling{i,j}) == 1
                    max_pooling{i,j} = video_pyramid_temp{i,j};
                end
                if length(sum_pooling{i,j}) == 1
                    sum_pooling{i,j} = video_pyramid_temp{i,j};
                end
            end
        end
        
        % Concate all parts into one arrey for each video
        max_pooling_temp = cell(length(data),1);
        sum_pooling_temp = cell(length(data),1);
        pooling_temp{level_num} = cell(length(data),1);
        if part_total > 1
            for part_num = 1:2:part_total
                max_pooling_temp = cellfun(@horzcat, max_pooling_temp(:,1), max_pooling(:,part_num), max_pooling(:,part_num+1), 'UniformOutput', false);
                sum_pooling_temp = cellfun(@horzcat, sum_pooling_temp(:,1), sum_pooling(:,part_num), sum_pooling(:,part_num+1), 'UniformOutput', false);
            end
            pooling_temp{level_num} = cellfun(@horzcat, max_pooling_temp(:,1), sum_pooling_temp(:,1), 'UniformOutput', false);
        else
                pooling_temp{level_num} = cellfun(@horzcat, max_pooling(:,1), sum_pooling(:,1), 'UniformOutput', false);
        end
    end
    
    % Concate all levels into one feature vector for each video
    pyramid_pooling_features = cell(length(data),1);
    for level_num = 1:length(pyramid_pooling_levels)
        pyramid_pooling_features = cellfun(@horzcat, pyramid_pooling_features(:,1), pooling_temp{level_num}(:,1), 'UniformOutput', false);
    end
    pyramid_pooling_features = pyramid_pooling_features{1,1};
    %%  Save Results and Label
    save (saveName, 'pyramid_pooling_features');
    
end