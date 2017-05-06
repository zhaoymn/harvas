function [qrs_amp_raw,qrs_time_raw,qrs_i_raw,RR]= QRSdetection_qu(ecg,fs)
data=ecg;
IndMax=find(diff(sign(diff(data)))<0)+1;   %找到所有的极值点（位置）
mean_IndMax=mean(data(IndMax));
%I=find(data(IndMax)>20*mean_IndMax);    %I为用所有极值的均值筛选过的极值点的序号
I=find(data(IndMax)>8*mean_IndMax);    %I为用所有极值的均值筛选过的极值点的序号
post_IndMax=zeros(length(I),1);
post_IndMax(:)=IndMax(I(:));   %post_IndMax为用所有极值的均值筛选过的极值点（峰的位置）

lim_post_IndMax=[];
lim_post_IndMax(1)=post_IndMax(1);
m=1;
for k=1:length(post_IndMax)-1
       if post_IndMax(k+1)-lim_post_IndMax(m)>0.4*fs
          lim_post_IndMax(m+1)=post_IndMax(k+1);
          m=m+1;
       end
end
lim_post_IndMax=lim_post_IndMax';

qrs_amp_raw=data(lim_post_IndMax);
qrs_i_raw=lim_post_IndMax;
% 获得QRS波出现的时刻
for i =1:length(qrs_i_raw)
    qrs_time_raw(i)=(qrs_i_raw(i)-1)/fs;
end
% 获得RR间期
RR=[];
for i=2:length(qrs_time_raw)
    RR(i-1)=abs(qrs_time_raw(i)-qrs_time_raw(i-1));
end
