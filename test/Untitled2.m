clc;clear all;
RR=[];
f='liaoxionghua_00_V5.txt';        
ECG=loadECG(f);
% ECG=ECG(1:1000,1:1000);
fs=500;gr=0;
[qrs_amp_raw,qrs_time_raw,qrs_i_raw,delay]=pan_tompkin(ECG(:,2),fs,gr);
plot(ECG(:,1),ECG(:,2),'b');
hold on;
plot(qrs_time_raw,ECG(qrs_i_raw,2),'r+');
for i=2:length(qrs_time_raw)
    RR(i-1)=abs(qrs_time_raw(i)-qrs_time_raw(i-1));
end