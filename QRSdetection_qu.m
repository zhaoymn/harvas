function [qrs_amp_raw,qrs_time_raw,qrs_i_raw,RR]= QRSdetection_qu(ecg,fs)
data=ecg;
IndMax=find(diff(sign(diff(data)))<0)+1;   %�ҵ����еļ�ֵ�㣨λ�ã�
mean_IndMax=mean(data(IndMax));
%I=find(data(IndMax)>20*mean_IndMax);    %IΪ�����м�ֵ�ľ�ֵɸѡ���ļ�ֵ������
I=find(data(IndMax)>8*mean_IndMax);    %IΪ�����м�ֵ�ľ�ֵɸѡ���ļ�ֵ������
post_IndMax=zeros(length(I),1);
post_IndMax(:)=IndMax(I(:));   %post_IndMaxΪ�����м�ֵ�ľ�ֵɸѡ���ļ�ֵ�㣨���λ�ã�

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
% ���QRS�����ֵ�ʱ��
for i =1:length(qrs_i_raw)
    qrs_time_raw(i)=(qrs_i_raw(i)-1)/fs;
end
% ���RR����
RR=[];
for i=2:length(qrs_time_raw)
    RR(i-1)=abs(qrs_time_raw(i)-qrs_time_raw(i-1));
end
