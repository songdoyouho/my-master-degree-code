actnum=conf.actnum;
numclusters=conf.numclusters;
tridx=conf.tridx;
teidx=conf.teidx;

% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         X=load(sprintf('%s\\output_global_and_local_traj\\localfeature%d_%d.txt', conf.videopath, vi, j));
%         fprintf('%s\\output_global_and_local_traj\\localfeature%d_%d.txt\n', conf.videopath, vi, j);
%         
%         X1 = X(:,2:33);   
%         
%         U = X1(:,1:2:31);
%         V = X1(:,2:2:32);
%         Pu = [];
%         Pv = [];
%         
%         for k = 1 : 15
%             tmp_Pu = U(:,k+1) - U(:,k);
%             tmp_Pv = V(:,k+1) - V(:,k);
%             Pu = [Pu tmp_Pu];
%             Pv = [Pv tmp_Pv];
%         end
%         
%         P = [];
%         for k = 1 : 15
%             P=[P Pu(:,k) Pv(:,k)];
%         end
%         
%         tmp_norm = sum(P,2);
%         norm = [];
%         for k = 1 : 30
%             norm = [norm tmp_norm];
%         end
%         % 把零的去掉
%         index = find(tmp_norm==0);
%         
%         norm(index,:)=[];
%         P(index,:)=[];
%         X(index,:)=[];       
%         
%         P = P./ norm;      
%         
%         X = [X P];
%         
% %         % normalize
% %         norm_Pu = [];
% %         norm_Pv = [];
% %         tmp_norm_Pu = abs(sum(Pu,2));
% %         tmp_norm_Pv = abs(sum(Pv,2));
% %         for k = 1 : 15
% %             norm_Pu = [norm_Pu tmp_norm_Pu];
% %             norm_Pv = [norm_Pv tmp_norm_Pv];
% %         end            
% %         Pu = Pu ./ norm_Pu;
% %         Pv = Pv ./ norm_Pv;
% %         
% %         for k = 1:15
% %             X=[X Pu(:,k) Pv(:,k)];
% %         end
%         
%         save(sprintf('%s\\output_global_and_local_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
%     end
% end
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         X=load(sprintf('%s\\output_global_and_local_traj\\localfeature%d_%d.txt', conf.videopath, vi, j));
%         fprintf('%s\\output_global_and_local_traj\\localfeature%d_%d.txt\n', conf.videopath, vi, j);
%         
%         X1 = X(:,2:33);   
%         
%         U = X1(:,1:2:31);
%         V = X1(:,2:2:32);
%         Pu = [];
%         Pv = [];
%         for k = 1 : 15
%             tmp_Pu = U(:,k+1) - U(:,k);
%             tmp_Pv = V(:,k+1) - V(:,k);
%             Pu = [Pu tmp_Pu];
%             Pv = [Pv tmp_Pv];
%         end
%         
%         P = [];
%         for k = 1:15
%             P=[P Pu(:,k) Pv(:,k)];
%         end
%         
%         tmp_norm = sum(P,2);
%         norm = [];
%         for k = 1 : 30
%             norm = [norm tmp_norm];
%         end
%         % 0
%         index = find(tmp_norm==0);
%         
%         norm(index,:)=[];
%         P(index,:)=[];
%         X(index,:)=[]; 
%                
%         P = P./ norm;      
%         
%         X = [X P];
%         
% %         % normalize
% %         norm_Pu = [];
% %         norm_Pv = [];
% %         tmp_norm_Pu = abs(sum(Pu,2));
% %         tmp_norm_Pv = abs(sum(Pv,2));
% %         for k = 1 : 15
% %             norm_Pu = [norm_Pu tmp_norm_Pu];
% %             norm_Pv = [norm_Pv tmp_norm_Pv];
% %         end            
% %         Pu = Pu ./ norm_Pu;
% %         Pv = Pv ./ norm_Pv;
% %         
% %         for k = 1:15
% %             X=[X Pu(:,k) Pv(:,k)];
% %         end
%         
%         save(sprintf('%s\\output_global_and_local_traj\\feature%d_%d.mat', conf.videopath, vi, j),'X');
%     end
% end


for j=1:actnum
    for i=1:numel(tridx{j,1})
        vi=tridx{j,1}(1,i);
        X=load(sprintf('%s\\output_global_and_local_traj\\global_traj_%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\output_global_and_local_traj\\global_traj_%d_%d.txt\n', conf.videopath, vi, j);
        
        X1 = X(:,2:33);   
        
        U = X1(:,1:16);
        V = X1(:,17:32);
        Pu = [];
        Pv = [];
        
        for k = 1 : 15
            tmp_Pu = U(:,k+1) - U(:,k);
            tmp_Pv = V(:,k+1) - V(:,k);
            Pu = [Pu tmp_Pu];
            Pv = [Pv tmp_Pv];
        end
        
        P = [];
        for k = 1 : 15
            P=[P Pu(:,k) Pv(:,k)];
        end
        
        tmp_norm = sum(P,2);
        norm = [];
        for k = 1 : 30
            norm = [norm tmp_norm];
        end
        % 把零的去掉
        index = find(tmp_norm==0);
        
        norm(index,:)=[];
        P(index,:)=[];
        X(index,:)=[];       
        
        P = P./ norm;      
        
        X = [X P];
        
        save(sprintf('%s\\output_global_and_local_traj\\global_feature%d_%d.mat', conf.videopath, vi, j),'X');
    end
end
for j=1:actnum
    for i=1:numel(teidx{j,1})
        vi=teidx{j,1}(1,i);
        X=load(sprintf('%s\\output_global_and_local_traj\\global_traj_%d_%d.txt', conf.videopath, vi, j));
        fprintf('%s\\output_global_and_local_traj\\global_traj_%d_%d.txt\n', conf.videopath, vi, j);
        
        X1 = X(:,2:33);   
        
        U = X1(:,1:16);
        V = X1(:,17:32);
        Pu = [];
        Pv = [];
        
        for k = 1 : 15
            tmp_Pu = U(:,k+1) - U(:,k);
            tmp_Pv = V(:,k+1) - V(:,k);
            Pu = [Pu tmp_Pu];
            Pv = [Pv tmp_Pv];
        end
        
        P = [];
        for k = 1 : 15
            P=[P Pu(:,k) Pv(:,k)];
        end
        
        tmp_norm = sum(P,2);
        norm = [];
        for k = 1 : 30
            norm = [norm tmp_norm];
        end
        % 把零的去掉
        index = find(tmp_norm==0);
        
        norm(index,:)=[];
        P(index,:)=[];
        X(index,:)=[];       
        
        P = P./ norm;      
        
        X = [X P];
        
        save(sprintf('%s\\output_global_and_local_traj\\global_feature%d_%d.mat', conf.videopath, vi, j),'X');
    end
end


%%
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         system(sprintf('get_feature.exe %d_%d.avi localfeature%d_%d.txt local_traj_%d_%d.txt',vi,j,vi,j,vi,j));
%         fprintf('get_feature.exe %d_%d.avi localfeature%d_%d.txt local_traj_%d_%d.txt',vi,j,vi,j,vi,j);
%     end
% end
% 
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         system(sprintf('get_feature.exe %d_%d.avi localfeature%d_%d.txt local_traj_%d_%d.txt',vi,j,vi,j,vi,j));
%         fprintf('get_feature.exe %d_%d.avi localfeature%d_%d.txt local_traj_%d_%d.txt',vi,j,vi,j,vi,j);
%     end
% end
% 
% for j=1:actnum
%     for i=1:numel(tridx{j,1})
%         vi=tridx{j,1}(1,i);
%         system(sprintf('get_feature.exe %d_%d.avi globalfeature%d_%d.txt global_traj_%d_%d.txt',vi,j,vi,j,vi,j));
%         fprintf('get_feature.exe %d_%d.avi globalfeature%d_%d.txt global_traj_%d_%d.txt',vi,j,vi,j,vi,j);
%     end
% end
% 
% for j=1:actnum
%     for i=1:numel(teidx{j,1})
%         vi=teidx{j,1}(1,i);
%         system(sprintf('get_feature.exe %d_%d.avi globalfeature%d_%d.txt global_traj_%d_%d.txt',vi,j,vi,j,vi,j));
%         fprintf('get_feature.exe %d_%d.avi globalfeature%d_%d.txt global_traj_%d_%d.txt',vi,j,vi,j,vi,j);
%     end
% end

