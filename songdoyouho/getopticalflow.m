function [  ] = getopticalflow( conf )
%GETOPTICALFLOW Summary of this function goes here
% this file extract optical flow using the code from 
% https://people.csail.mit.edu/celiu/OpticalFlow/
% the output is y,x,t with Vx and Vy
%   Detailed explanation goes here
actnum=conf.actnum;
tridx=conf.tridx;
teidx=conf.teidx;
addpath(genpath(conf.opticalflow));
mkdir(sprintf('%s\\TVL1_opticalflow',conf.videopath));
% optical flow parameters
alpha = 0.01;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        % read video
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        
        allVx = [];
        allVy = [];
        
        for k = 1 : endframe - 1
            k
            thisframe = read(mov,k);
            nextframe = read(mov,k+1);
            
            % extract optical flow
            [Vx,Vy,warpI2] = Coarse2FineTwoFrames(thisframe,nextframe,para);
            
            allVx = cat(3,allVx,Vx);
            allVy = cat(3,allVy,Vy);          
        end
        TVL1_flow.allVx = allVx;
        TVL1_flow.allVy = allVy;        
        save(sprintf('%s\\TVL1_opticalflow\\%d_%d.mat',conf.videopath,vi,j),'TVL1_flow');  
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        endframe = mov.NumberOfFrames;
        
        allVx = [];
        allVy = [];
        
        for k = 1 : endframe - 1
            k
            thisframe = read(mov,k);
            nextframe = read(mov,k+1);
            
            % TVL1
            [Vx,Vy,warpI2] = Coarse2FineTwoFrames(thisframe,nextframe,para);
            
            allVx = cat(3,allVx,Vx);
            allVy = cat(3,allVy,Vy);
        end
        TVL1_flow.allVx = allVx;
        TVL1_flow.allVy = allVy;
        save(sprintf('%s\\TVL1_opticalflow\\%d_%d.mat',conf.videopath,vi,j),'TVL1_flow');  
    end
end
end

