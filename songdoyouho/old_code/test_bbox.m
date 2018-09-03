function [ ] = test_bbox( conf )
%   讀每部影片，拿到想要的bounding box，存下來
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
videonumber=conf.videonumber;
addpath(genpath('C:\Users\diesel\Desktop\voc-release3.1'));

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % load video
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        numberOfFrames = mov.NumberOfFrames;
        if j==1
            % record tested bbox and save
            all_info_boxes = [];
            for frame = 1 : numberOfFrames
                thisFrame = read(mov, frame);
                % load and display model
                load('C:\Users\diesel\Desktop\songdoyouho\part_based_model\dogcar_final');
                % detect objects
                boxes = detect(thisFrame, model, 0);
                % get bounding boxes
                bbox = getboxes(model, boxes);
                top = nms(bbox, 0.5);
                bbox = clipboxes(thisFrame, top);
                info_boxes = getbboxes(bbox, frame);
                if isempty(info_boxes)
                    info_boxes = [frame 0 0 0 0];
                end
                all_info_boxes = [all_info_boxes; info_boxes];
            end
        else
            % record tested bbox and save
            all_info_boxes = [];
            for frame = 1 : numberOfFrames
                thisFrame = read(mov, frame);
                % load and display model
                load('C:\Users\diesel\Desktop\songdoyouho\part_based_model\doghead_final');
                % detect objects
                boxes = detect(thisFrame, model, 0);
                % get bounding boxes
                bbox = getboxes(model, boxes);
                top = nms(bbox, 0.5);
                bbox = clipboxes(thisFrame, top);
                info_boxes = getbboxes(bbox, frame);
                if isempty(info_boxes)
                    info_boxes = [frame 0 0 0 0];
                end
                all_info_boxes = [all_info_boxes; info_boxes];
            end
        end
        save(sprintf('%s\\all_info_boxes\\%d_%d.mat',conf.tmppath ,vi ,j),'all_info_boxes');
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        % load video
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        fprintf('%s\\%d_%d.avi\n', conf.videopath, vi, j);
        numberOfFrames = mov.NumberOfFrames;
        if j==1
            % record tested bbox and save
            all_info_boxes = [];
            for frame = 1 : numberOfFrames
                thisFrame = read(mov, frame);
                % load and display model
                load('C:\Users\diesel\Desktop\songdoyouho\part_based_model\dogcar_final');
                % detect objects
                boxes = detect(thisFrame, model, 0);
                % get bounding boxes
                bbox = getboxes(model, boxes);
                top = nms(bbox, 0.5);
                bbox = clipboxes(thisFrame, top);
                info_boxes = getbboxes(bbox, frame);
                if isempty(info_boxes)
                    info_boxes = [frame 0 0 0 0];
                end
                all_info_boxes = [all_info_boxes; info_boxes];
            end
        else
            % record tested bbox and save
            all_info_boxes = [];
            for frame = 1 : numberOfFrames
                thisFrame = read(mov, frame);
                % load and display model
                load('C:\Users\diesel\Desktop\songdoyouho\part_based_model\doghead_final');
                % detect objects
                boxes = detect(thisFrame, model, 0);
                % get bounding boxes
                bbox = getboxes(model, boxes);
                top = nms(bbox, 0.5);
                bbox = clipboxes(thisFrame, top);
                info_boxes = getbboxes(bbox, frame);
                if isempty(info_boxes)
                    info_boxes = [frame 0 0 0 0];
                end
                all_info_boxes = [all_info_boxes; info_boxes];
            end
        end
        save(sprintf('%s\\all_info_boxes\\%d_%d.mat',conf.tmppath ,vi ,j),'all_info_boxes');
    end
end
end



