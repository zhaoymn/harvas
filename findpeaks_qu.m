function [pks,locs] = findpeaks_qu(ecg)  
%��������ֵpost_IndMax��data(post_IndMax)�ֱ��Ǹ÷����ҵ��ķ������λ�úͷ�ֵ
data=ecg;
IndMax=find(diff(sign(diff(data)))<0)+1;   %�ҵ����еļ�ֵ�㣨λ�ã�
pks=data(IndMax);
locs=IndMax;

% figure;
% plot(data);
% hold on;
% plot(IndMax,data(IndMax),'ro');
% end
