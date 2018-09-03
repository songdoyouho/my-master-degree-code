function motion_decomp( conf, FACTOR , choose_dataset )
actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;
addpath (genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
output_video = 0;

rg_rate = cell(10,4);
count = 0;

for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        rg_rate{j,1} = sprintf('%d',j);
        load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));%all_improved_traj\\
        fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j); %all_improved_traj\\
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        all_label = cell(1,endframe+1-startframe);
        outindex = [];
        for k = startframe : endframe
            thisframe = read(mov,k);
            % this frame
            index=X(:,1)==k;
            tmpX=X(index,:);
            if size(tmpX,1) >= 3
                X1 = tmpX(:,2:31);
                U = X1(:,1:2:29);
                V = X1(:,2:2:30);
                Traj = [U V];
                [tmp_outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
                outindex = [outindex; tmp_outindex'];
                outX = tmpX(tmp_outindex,:);  % 選完的 X
                if isempty(rg_rate{j,2})
                    rg_rate{j,2}=size(outX,1);
                    rg_rate{j,3}=size(X,1)-size(outX,1);
                    rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
                else
                    rg_rate{j,2}=size(outX,1) + rg_rate{j,2};
                    rg_rate{j,3}=size(X,1)-size(outX,1) + rg_rate{j,3};
                    rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
                end
            else
                outindex = [outindex; ones(size(tmpX,1),1)];
            end
            label = double(tmp_outindex');
            all_label{1,k} = label;
            % selected
            index=outX(:,1)==k;
        end
        save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
        save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
        count = count + 1;
    end
end

for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        rg_rate{j,1} = sprintf('%d',j);
        load(sprintf('%s\\all_improved_traj\\feature%d_%d.mat', conf.videopath, vi, j));%all_improved_traj\\
        fprintf('%s\\all_improved_traj\\feature%d_%d.mat\n', conf.videopath, vi, j); %all_improved_traj\\
        mov = VideoReader(sprintf('%s\\%d_%d.avi', conf.videopath, vi, j));
        startframe = X(1,1);
        endframe = mov.NumberOfFrames;
        all_label = cell(1,endframe+1-startframe);
        outindex = [];
        for k = startframe : endframe
            thisframe = read(mov,k);
            % this frame
            index=X(:,1)==k;
            tmpX=X(index,:);
            if size(tmpX,1) >= 3
                X1 = tmpX(:,2:31);
                U = X1(:,1:2:29);
                V = X1(:,2:2:30);
                Traj = [U V];
                [tmp_outindex,EE,outinds,TrajOut,TrajIn,TrajOutLow,TrajOutE] = MotionDecomp(Traj,FACTOR);
                outindex = [outindex; tmp_outindex'];
                outX = tmpX(tmp_outindex,:);  % 選完的 X
                if isempty(rg_rate{j,2})
                    rg_rate{j,2}=size(outX,1);
                    rg_rate{j,3}=size(X,1)-size(outX,1);
                    rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
                else
                    rg_rate{j,2}=size(outX,1) + rg_rate{j,2};
                    rg_rate{j,3}=size(X,1)-size(outX,1) + rg_rate{j,3};
                    rg_rate{j,4}=rg_rate{j,2}/rg_rate{j,3};
                end
            else
                outindex = [outindex; ones(size(tmpX,1),1)];
            end
            label = double(tmp_outindex');
            all_label{1,k} = label;
            % selected
            index=outX(:,1)==k;
        end
        save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
        save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
        count = count + 1;
    end
end


if strcmp(choose_dataset,'dog')
    for j=1:actnum
        for i=1:numel(tridx{j,1})
            vi=tridx{j,1}(1,i);
            if j == 2 || j == 7 || j == 8 || j == 9 || j == 10 % global action
                fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
                load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
                load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
                for k = 1 : size(all_label,2)
                    tmp_cell = all_label{1,k};
                    if isempty(tmp_cell)==0
                        %                     tmp_cell = double(not(tmp_cell));
                        tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
                        all_label{1,k} = tmp_cell;
                    end
                end
                outindex = not(outindex);
                save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
                save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
            end
        end
    end
    
    for j=1:actnum
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            if j == 2 || j == 7 || j == 8 || j == 9 || j == 10 % global action
                fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
                load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
                load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
                for k = 1 : size(all_label,2)
                    tmp_cell = all_label{1,k};
                    if isempty(tmp_cell)==0
                        %                     tmp_cell = double(not(tmp_cell));
                        tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
                        all_label{1,k} = tmp_cell;
                    end
                end
                outindex = not(outindex);
                save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
                save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
            end
        end
    end
end
if strcmp(choose_dataset,'jpl')
    for j=1:actnum
        for i=1:numel(tridx{j,1})
            vi=tridx{j,1}(1,i);
            if j == 2 || j == 3 || j == 6
                fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
                load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
                load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
                for k = 1 : size(all_label,2)
                    tmp_cell = all_label{1,k};
                    if isempty(tmp_cell)==0
                        %                     tmp_cell = double(not(tmp_cell));
                        tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
                        all_label{1,k} = tmp_cell;
                    end
                end
                outindex = not(outindex);
                save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
                save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
            end
        end
    end
    
    for j=1:actnum
        for i=1:numel(teidx{j,1})
            vi=teidx{j,1}(1,i);
            if j == 2 || j == 3 || j == 6
                fprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j)
                load(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j));
                load(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j));
                for k = 1 : size(all_label,2)
                    tmp_cell = all_label{1,k};
                    if isempty(tmp_cell)==0
                        %                     tmp_cell = double(not(tmp_cell));
                        tmp_cell = ones(size(tmp_cell,1),size(tmp_cell,2));
                        all_label{1,k} = tmp_cell;
                    end
                end
                outindex = not(outindex);
                save(sprintf('%s\\motion_all_label\\%d_%d.mat', conf.tmppath, vi,j),'all_label');
                save(sprintf('%s\\motion_all_label\\outindex%d_%d.mat', conf.tmppath, vi,j),'outindex');
            end
        end
    end
end
rmpath(genpath('C:\\Users\\diesel\\Desktop\\Oreifej_RPCA\\'));
end

