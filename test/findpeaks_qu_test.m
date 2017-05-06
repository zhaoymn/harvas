clc;clear;
data=importdata('huqiuye_00_V5.txt');
fs=500;
IndMax=find(diff(sign(diff(data)))<0)+1;   %找到所有的极值点（位置）
mean=mean(data(IndMax));
I=find(data(IndMax)>20*mean);    %I为用所有极值的均值筛选过的极值点的序号
post_IndMax=zeros(length(I),1);
post_IndMax(:)=IndMax(I(:));   %post_IndMax为用所有极值的均值筛选过的极值点（峰的位置）

lim_post_IndMax=[];
lim_post_IndMax(1)=post_IndMax(1);
m=1;
for k=1:length(post_IndMax)-1
       if post_IndMax(k+1)-lim_post_IndMax(m)>0.6*fs
          lim_post_IndMax(m+1)=post_IndMax(k+1);
          m=m+1;
       end
end
lim_post_IndMax=lim_post_IndMax';

figure;
plot(data);
hold on;
plot(IndMax,data(IndMax),'go');
hold on;
plot(post_IndMax,data(post_IndMax),'k*');
hold on;
plot(lim_post_IndMax,data(lim_post_IndMax),'r+');
