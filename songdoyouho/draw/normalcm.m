function normalcm(CM,name,nclass)



for k=1:nclass
a(k)=sum(CM(k,:));
norCM(k,:)=CM(k,:)/a(k);
end

draw_cm(norCM,name,nclass);
end