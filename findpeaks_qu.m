function [pks,locs] = findpeaks_qu(ecg)  
%两个返回值post_IndMax和data(post_IndMax)分别是该方法找到的峰的所在位置和峰值
data=ecg;
IndMax=find(diff(sign(diff(data)))<0)+1;   %找到所有的极值点（位置）
pks=data(IndMax);
locs=IndMax;

% figure;
% plot(data);
% hold on;
% plot(IndMax,data(IndMax),'ro');
% end
