clc;clear;
val=importdata('huqiuye_00_V5.txt');
 p=43190000;  %�ĵ����ݲ鿴���
 q=43196990;  %�ĵ����ݲ鿴�յ�
 ecg=val(p:q);
%ecg=val;
% Ԥ���޳�ԭʼecg�ź��е�ѹֵ���ڣ�-100*mean_tmpData��200*mean_tmpData�����쳣��
mean_ecg=mean(ecg);
position1=find(ecg(:)>200*mean_ecg);
ecg(position1)=[];
position2=find(ecg(:)<-100*mean_ecg);
ecg(position2)=[];
% figure;
% plot(ecg);
fs=500;
N=length(ecg);
tic
[qrs_amp_raw,qrs_time_raw,qrs_i_raw,RR]= QRSdetection_qu(ecg,fs);
toc
tic
figure;
plot(ecg,'LineWidth',0.5);
hold on;
for k=1:1:length(qrs_i_raw)
    plot(qrs_i_raw(k),ecg(qrs_i_raw(k)),'r+','LineWidth',1); %�����㷨��ע���
    hold on;
end
toc