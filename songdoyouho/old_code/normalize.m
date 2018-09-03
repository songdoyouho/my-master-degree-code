function [  ] = normalize( conf, flag )
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
actnum=conf.actnum;
tridx=conf.tridx;
teidx=conf.teidx;
if(strcmp(flag, 'train'))
    for j=1:actnum
        for i=1:numel(tridx)
            vi=tridx(i);
            %X=[];
            for fnum=1:1
                load(sprintf('%s\\histogram%d_%d_%d.mat',conf.tmppath,fnum,vi,j));
                fprintf('%s\\histogram%d_%d_%d.mat\n',conf.tmppath,fnum,vi,j);
                eval(sprintf('Z = Z%d;',fnum));
                Z=Z/norm(Z);
                %X=[X Z];
            end
            %X=X/norm(X);
            % PCA
%             [coeff, score, latent, tsquare] = princomp(Z);
%             newcoeff=coeff(:,1:conf.dim);
%             newX=Z*newcoeff;
            figure;
            bar(Z);
            save(sprintf('%s\\normhist%d_%d.mat',conf.tmppath,vi,j),'Z');
        end
    end
end

if(strcmp(flag, 'test'))
    for j=1:actnum
        for i=1:numel(teidx)
            vi=teidx(i);
            X=[];
            for fnum=1:4
                load(sprintf('%s\\histogram%d_%d_%d.mat',conf.videopath,fnum,vi,j));
                fprintf('%s\\histogram%d_%d_%d.mat\n',conf.videopath,fnum,vi,j);
                eval(sprintf('Z = Z%d;',fnum));
                X=X/norm(X);
                X=[X Z];
            end
            %X=X/norm(X);
            % PCA
            [coeff, score, latent, tsquare] = princomp(X);
            newcoeff=coeff(:,1:conf.dim);
            newX=X*newcoeff;
            figure;
            bar(newX);
            save(sprintf('%s\\normhist%d_%d.mat',conf.tmppath,vi,j),'newX');
        end
    end
end
end

