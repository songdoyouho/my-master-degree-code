function [  ] = gpc( conf, flag )
%GPC Summary of this function goes here
%   Detailed explanation goes here
actnum=conf.actnum;
tridx=conf.tridx;
teidx=conf.teidx;

if(strcmp(flag, 'train'))
    % training video
    Z=[];
    for j=1:actnum %動作
        for i=1:numel(tridx) %影片
            vi=tridx(i);
            load(sprintf('%s\\normhist%d_%d.mat',conf.tmppath,vi,j));
            fprintf('%s\\normhist%d_%d.mat\n',conf.tmppath,vi,j);
            Z=[Z; X];
        end
    end
    
    meanfunc = @meanZero;
    covfunc = {@covSum, {@covSEiso, @covNoise}};
    likfunc = @likGauss;
    
    for j=1:actnum
        Y=-ones(size(Z,1),1);
        count=j*6;
        for i=(count-5):count
            Y(i,1)=1;
        end
        % training gp
        hyp.cov = [0; 0; 0];
        hyp.lik = log(0.1);
        allhyp(j).hyp = minimize(hyp, @gp, -100, @infExact, meanfunc, covfunc, likfunc, Z, Y);
        allhyp(j).nlml2 = gp(hyp, @infExact, meanfunc, covfunc, likfunc, Z, Y);
        save(sprintf('%s//train%d.mat',conf.tmppath,j),'Z');
        save(sprintf('%s//label%d.mat',conf.tmppath,j),'Y');
        save(sprintf('%s//allhyp.mat',conf.tmppath),'allhyp');
    end
end

if(strcmp(flag, 'test'))
    meanfunc = @meanZero;
    covfunc = {@covSum, {@covSEiso, @covNoise}};
    likfunc = @likGauss; 
    load(sprintf('%s//allhyp.mat',conf.videopath));
    for j=1:actnum %動作
        for i=1:numel(teidx) %影片
            vi=teidx(i);
            load(sprintf('%s\\normhist%d_%d.mat',conf.tmppath,vi,j));
            load(sprintf('%s\\train%d.mat',conf.tmppath,j));
            load(sprintf('%s\\label%d.mat',conf.tmppath,j));
            fprintf('%s\\normhist%d_%d.mat\n',conf.tmppath,vi,j);
            alllp=[];
            for k=1:actnum
                [ymu ys2 fmu fs2 lp] = gp(allhyp(k).hyp, @infExact, meanfunc, covfunc, likfunc, Z, Y, X,ones(42,1));
                lp=exp(lp);
                alllp=[alllp lp];
                [I D]=sort(alllp,'descend');
                result.lp=alllp(D(1,1));
                result.class=[j D(1,1)];
                save(sprintf('%s\\result%d_%d.mat',conf.tmppath,vi,j),'result');
            end
        end
    end        
end
end

